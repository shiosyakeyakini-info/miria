import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

class FederationAnnouncements extends HookConsumerWidget {
  final String host;
  const FederationAnnouncements({required this.host, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = useState(true);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: ToggleButtons(
                  isSelected: [
                    isActive.value,
                    !isActive.value,
                  ],
                  onPressed: (value) {
                    switch (value) {
                      case 0:
                        isActive.value = true;
                      case 1:
                        isActive.value = false;
                    }
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(S.of(context).activeAnnouncements),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(S.of(context).inactiveAnnouncements),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: PushableListView(
            listKey: isActive.value,
            initializeFuture: () async {
              final Iterable<AnnouncementsResponse> response;
              final request =
                  AnnouncementsRequest(isActive: isActive.value, limit: 10);
              response = await ref
                  .read(misskeyGetContextProvider)
                  .announcements(request);
              return response.toList();
            },
            nextFuture: (lastItem, offset) async {
              final Iterable<AnnouncementsResponse> response;
              // 互換性のためにuntilIdとoffsetを両方いれる
              final request = AnnouncementsRequest(
                untilId: lastItem.id,
                isActive: isActive.value,
                limit: 30,
                offset: offset,
              );
              response = await ref
                  .read(misskeyGetContextProvider)
                  .announcements(request);
              return response.toList();
            },
            itemBuilder: (context, data) =>
                Announcement(initialData: data, host: host),
          ),
        ),
      ],
    );
  }
}

class Announcement extends HookConsumerWidget {
  final AnnouncementsResponse initialData;
  final String host;

  const Announcement({
    required this.initialData,
    required this.host,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = useState(initialData);
    final icon = data.value.icon;
    final imageUrl = data.value.imageUrl;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (data.value.forYou == true)
                Text(
                  S.of(context).announcementsForYou,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              Row(
                children: [
                  if (icon != null) AnnouncementIcon(iconType: icon),
                  Expanded(
                    child: MfmText(
                      mfmText: data.value.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(data.value.createdAt.format(context)),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              MfmText(
                mfmText: data.value.text,
                host: ref.read(accountContextProvider).isSame ? null : host,
              ),
              if (imageUrl != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: NetworkImageView(
                      url: imageUrl.toString(),
                      type: ImageType.image,
                    ),
                  ),
                ),
              if (ref.read(accountContextProvider).isSame &&
                  data.value.isRead == false)
                ElevatedButton(
                  onPressed: () async {
                    if (data.value.needConfirmationToRead == true) {
                      final isConfirmed = await SimpleConfirmDialog.show(
                        context: context,
                        message: S
                            .of(context)
                            .confirmAnnouncementsRead(data.value.title),
                        primary: S.of(context).readAnnouncement,
                        secondary: S.of(context).didNotReadAnnouncement,
                      );
                      if (isConfirmed != true) return;
                    }

                    await ref
                        .read(misskeyPostContextProvider)
                        .i
                        .readAnnouncement(
                          IReadAnnouncementRequest(
                            announcementId: data.value.id,
                          ),
                        );
                    data.value = data.value.copyWith(isRead: true);
                  },
                  child: Text(S.of(context).done),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnouncementIcon extends StatelessWidget {
  final AnnouncementIconType iconType;

  const AnnouncementIcon({
    required this.iconType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (iconType) {
      case AnnouncementIconType.info:
        return const Icon(Icons.info);
      case AnnouncementIconType.warning:
        return const Icon(
          Icons.warning,
          color: Colors.yellow,
        );
      case AnnouncementIconType.error:
        return const Icon(Icons.error, color: Colors.red);
      case AnnouncementIconType.success:
        return const Icon(Icons.check, color: Colors.blue);
      default:
        return const SizedBox.shrink();
    }
  }
}
