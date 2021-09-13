import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonTextfield.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';

class ReportBlock extends StatefulWidget {
  final int userId;
  final String reportImageURl, gender;
  ReportBlock(
      {Key key,
      @required this.userId,
      @required this.reportImageURl,
      @required this.gender})
      : super(key: key);

  @override
  _ReportBlockState createState() => _ReportBlockState();
}

class _ReportBlockState extends State<ReportBlock> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportAndBlockProvider>(context, listen: false)
          .fetchReportReason(context);
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<ReportAndBlockProvider>(context, listen: false)
        .reportReasonList
        .forEach((element) {
      if (element.isSelected == true) {
        element.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
        context,
        "Report",
        isWhite: true,
        leadingButton: getBackButton(context),
      ),
      body: Consumer<ReportAndBlockProvider>(
        builder: (context, reportProvider, child) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: getSize(32), right: getSize(32)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getProfileImage(),
                        SizedBox(
                          height: getSize(20),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: getRadioButton(
                                reportProvider
                                        .reportReasonList[index]?.reason ??
                                    "",
                                reportProvider,
                                index),
                          ),
                          itemCount: reportProvider.reportReasonList.length,
                        ),
                        CommonTextfield(
                          textOption: TextFieldOption(
                              hintText: "Input report reason",
                              maxLine: 5,
                              inputController: _reasonController),
                          textCallback: (text) {},
                        ),
                        SizedBox(
                          height: getSize(16),
                        ),
                      ],
                    ),
                  ),
                ),
                // getReportButton(),
                // SizedBox(
                //   height: getSize(16),
                // ),
                getPopBottomButton(context, "Report & Block", () {
                  int reasonId = reportProvider?.reportReasonList?.firstWhere(
                      (element) => element.isSelected == true, orElse: () {
                    View.showMessage(context, "Please select any reason");
                  })?.id;
                  if (reasonId == null) {
                    return;
                  }
                  reportProvider.blockAndReportUser(context, widget.userId,
                      reasonId, _reasonController?.text ?? "");
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getReportButton() {
    return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.red, width: 1),
          borderRadius: BorderRadius.circular(
            getSize(16),
          ),
          color: fromHex("#FFDFDF"),
        ),
        child: Center(
          child: Text("Report",
              style: appTheme.black16Bold.copyWith(
                  color: ColorConstants.red, fontSize: getFontSize(18))),
        ));
  }

  Widget getRadioButton(
      String text, ReportAndBlockProvider reportProvider, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (mounted) setState(() {});
        reportProvider.reportReasonList.forEach((element) {
          if (element.isSelected == true) {
            element.isSelected = false;
          }
        });
        reportProvider.reportReasonList[index].isSelected =
            !reportProvider.reportReasonList[index].isSelected;
      },
      child: Container(
        width: MathUtilities.screenWidth(context),
        decoration: BoxDecoration(
          color: fromHex("#F6F6F6"),
          borderRadius: BorderRadius.circular(
            getSize(10),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(getSize(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: appTheme.black14Normal
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Image.asset(
                  reportProvider.reportReasonList[index].isSelected
                      ? radioSelected
                      : radio,
                  height: getSize(18),
                  width: getSize(18),
                )
              ],
            )),
      ),
    );
  }

  Widget getProfileImage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: getSize(21)),
        child: Container(
          width: getSize(156),
          height: getSize(210),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 7,
                  spreadRadius: 5,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(
              getSize(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              getSize(20),
            ),
            child: CachedNetworkImage(
              imageUrl: (widget.reportImageURl ?? ""),
              width: getSize(156),
              height: getSize(210),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                getUserPlaceHolder(widget?.gender ?? ""),
                fit: BoxFit.cover,
                width: getSize(156),
                height: getSize(210),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
