import 'package:flutter/material.dart';


class RoleBottomSheet extends StatefulWidget {
  final Function(String selectedCategory) onCategorySelected;
  final Function() onClose;
  const RoleBottomSheet(
      {Key? key, required this.onCategorySelected, required this.onClose})
      : super(key: key);

  @override
  State<RoleBottomSheet> createState() =>
      _RoleBottomSheetState();
}

class freqlist {
  String? name;
  int? id;

  freqlist({this.name, this.id});
}

class _RoleBottomSheetState  extends State<RoleBottomSheet> {

  final List<String> _roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];


  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 250,
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey)),
        child: Column(

          children: <Widget>[
            ListView.separated(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    widget.onCategorySelected(
                        _roles[index].toString());
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _roles[index].toString(),
                        style: TextStyle(color: Colors.black87),
                        textAlign: TextAlign.center
                    ),
                  ),
                ),
                separatorBuilder: (context, index) {
                  return Divider(
                     height: 1,
                    color: Colors.grey.shade200,
                  );
                },
                itemCount: _roles.length),
          ],
        ),
      ),
    );
  }
}
