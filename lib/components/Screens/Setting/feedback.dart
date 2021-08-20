import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/provider/feedback_provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController textEditingController = TextEditingController();
  List<Asset> images = <Asset>[];
  @override
  void deactivate() {
    super.deactivate();
    Provider.of<FeedBackProvider>(context, listen: false)
        .feedBackList
        .forEach((element) {
      if (element.isSelected == true) {
        element.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedBackProvider>(
      builder: (context, feedbackProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(
          context,
          "Feedback",
          isWhite: true,
          leadingButton: getBackButton(context),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15.0),
          child: getBottomButton(context, "Submit", () {
            int categoryId = feedbackProvider?.feedBackList?.firstWhere(
                // ignore: missing_return
                (element) => element.isSelected == true, orElse: () {
              View.showMessage(context, "Please select any reason");
            })?.id;
            if (categoryId == null) {
              return;
            }
            feedbackProvider.submitFeedBack(
                context, categoryId, images, textEditingController?.text ?? "");
            Navigator.of(context).pop();
          }),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  "Feedback",
                  style: appTheme.black14Normal
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: getRadioButton(
                        feedbackProvider.feedBackList[index]?.category ?? "",
                        feedbackProvider,
                        index),
                  ),
                  itemCount: feedbackProvider.feedBackList.length,
                ),
                CommonTextfield(
                  textOption: TextFieldOption(
                      hintText: "A maximum of 1000 words can be input",
                      maxLine: 10,
                      inputController: textEditingController),
                  textCallback: (text) {},
                ),
                SizedBox(height: 20),
                Text(
                  "Upload Pictures",
                  style: appTheme.black14Normal
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: (images?.isEmpty ?? true)
                      ? List.generate(2, (index) {
                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              loadAssets();
                            },
                            child: Image.asset(
                              "assets/Profile/no_image.png",
                              width: 100,
                              height: 100,
                            ),
                          );
                        })
                      : List.generate(images.length, (index) {
                          Asset asset = images[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              AssetThumb(
                                asset: asset,
                                width: 100,
                                height: 100,
                              ),
                              Container(
                                color: Colors.black26,
                                child: IconButton(
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    )),
                              )
                            ],
                          );
                        }),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Video chat App",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Widget getRadioButton(
      String text, FeedBackProvider reportProvider, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (mounted) setState(() {});
        reportProvider.feedBackList.forEach((element) {
          if (element.isSelected == true) {
            element.isSelected = false;
          }
        });
        reportProvider.feedBackList[index].isSelected =
            !reportProvider.feedBackList[index].isSelected;
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
                  reportProvider.feedBackList[index].isSelected
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
}
