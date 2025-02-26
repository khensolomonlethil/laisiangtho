import 'package:flutter/material.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends SheetStates<Main> {
  @override
  double get actualInitialSize => 0.5;
  @override
  double get actualMinSize => 0.4;

  late final Poll poll = app.poll;

  late final List<PollMemberType> member = poll.pollBoard.member
    ..sort((a, b) => a.name.compareTo(b.name));
  List<PollResultType> get result => poll.pollBoard.result;
  bool hasUserVoted(int id) => result.where((e) => e.memberId.contains(id)).isNotEmpty;
  Iterable<PollMemberType> get voteList => member.where(
        (e) => result.where((r) => r.memberId.contains(e.memberId)).isNotEmpty,
      );
  int get countVotedMember => voteList.length;
  int get countMember => member.length;

  @override
  List<Widget> slivers() {
    return <Widget>[
      /*
      ViewBarSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        backgroundColor: Colors.transparent,
        overlapsBackgroundColor: theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: (_, vbd) {
          return ViewBarLayouts(
            data: vbd,
            primary: ViewBarTitle(
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, .5),
              //   vbd.snapShrink,
              // ),
              alignment: const Alignment(0, -.5),
              data: vbd,
              label: 'Member',
              // label: 'အဖွဲ့ဝင်',
            ),
            secondary: ViewBarTitle(
              // alignment: Alignment.lerp(
              //   const Alignment(0, .5),
              //   const Alignment(0, .5),
              //   vbd.snapShrink,
              // ),
              alignment: const Alignment(0, .7),
              data: vbd,
              shrinkMax: 20,
              shrinkMin: 12,
              label: 'MV: $countMember/$countVotedMember',
            ),
            // secondary: ViewHeaderBar(
            //   shrink: vbd.snapShrink,
            //   label: 'MV: $countMember/$countVotedMember',
            // ),
          );
        },
      ),
      */

      AppBarSliver.adaptive(
        children: [
          AdaptiveAppBar(
              height: const [kToolbarHeight, 50],
              builder: (_, vbd) {
                return ViewBarLayouts(
                  data: vbd,
                  primary: ViewBarTitle(
                    // alignment: Alignment.lerp(
                    //   const Alignment(0, 0),
                    //   const Alignment(0, .5),
                    //   vbd.snapShrink,
                    // ),
                    alignment: const Alignment(0, -.5),
                    data: vbd,
                    label: 'Member',
                    // label: 'အဖွဲ့ဝင်',
                  ),
                  secondary: ViewBarTitle(
                    // alignment: Alignment.lerp(
                    //   const Alignment(0, .5),
                    //   const Alignment(0, .5),
                    //   vbd.snapShrink,
                    // ),
                    alignment: const Alignment(0, .7),
                    data: vbd,
                    shrinkMax: 20,
                    shrinkMin: 12,
                    label: 'MV: $countMember/$countVotedMember',
                  ),
                  // secondary: ViewHeaderBar(
                  //   shrink: vbd.snapShrink,
                  //   label: 'MV: $countMember/$countVotedMember',
                  // ),
                );
              }),
        ],
      ),
      ViewSections(
        // headerTitle: const WidgetLabel(
        //   // alignment: Alignment.centerLeft,
        //   label: '...',
        // ),
        headerTitle: ViewButtons(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const WorkingMemberInfo()),
            // );
            // navigator.currentState!.pushNamed('testing');
          },
          child: const Text('Nav'),
        ),
        child: ViewLists(
          duration: const Duration(milliseconds: 900),
          itemSnap: ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).focusColor,
            ),
            title: Container(
              height: 15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              // color: Colors.grey[200],
            ),
            subtitle: Container(
              height: 15,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              // color: Colors.grey[200],
            ),
          ),
          itemBuilder: (_, index) {
            final person = member.elementAt(index);
            final hasVoted = hasUserVoted(person.memberId);
            return ListTile(
              leading: Icon(
                Icons.person,
                color: hasVoted ? null : Theme.of(context).focusColor,
              ),
              title: Text(person.name),
              trailing: Icon(
                Icons.done_outlined,
                color: hasVoted ? null : Colors.transparent,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: person.email.map(
                  (email) {
                    return Tooltip(
                      message: email,
                      child: Text(
                        email.substring(0, email.indexOf('@')),
                        style: context.style.labelSmall!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          },
          itemCount: countMember,
        ),
      ),
    ];
  }
}
