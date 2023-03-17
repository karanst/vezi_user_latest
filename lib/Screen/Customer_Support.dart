import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:vezi/Helper/AppBtn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../Helper/AppBtn.dart';
import '../Helper/Session.dart';
import 'Chat.dart';
import '../Helper/Color.dart';
// import 'package:vezi/Helper/Session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart'as http;

import '../Helper/Constant.dart';
import '../Helper/SimBtn.dart';
import '../Helper/String.dart';
import '../Model/Model.dart';

class CustomerSupport extends StatefulWidget {
  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport>
    with TickerProviderStateMixin {
  bool _isLoading = true, _isProgress = false;
  Animation? buttonSqueezeanimation;
  late AnimationController buttonController;
  bool _isNetworkAvail = true;
  List<Model> typeList = [];
  List<Model> ticketList = [];
  Model? ticketData;
  List<Model> statusList = [];
  List<Model> tempList = [];
  String? type, email, title, desc, status, id;
  FocusNode? nameFocus, emailFocus, descFocus;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final descController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool edit = false, show = false;
  bool fabIsVisible = true;
  ScrollController controller = new ScrollController();
  int offset = 0;
  int total = 0, curEdit = -1;
  bool isLoadingmore = true;
  File? aadharImage;
  List? ticketImageData ;
  var images;


  final ImagePicker imgpicker = ImagePicker();
  List<PickedFile> imageList = [];
  final List<File> _image = [];

  addImage(PickedFile _image){
    setState(() {
      imageList.add(_image);
    });
  }

  List<String> selectedImageList = [];

  @override
  void initState() {
    super.initState();
    statusList = [
      Model(id: "3", title: "Resolved"),
      Model(id: "5", title: "Reopen")
    ];
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabIsVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;

        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange) {
          isLoadingmore = true;

          if (offset < total) getTicket();
        }
      });
    });
    getType();
    getTicket();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
          getSimpleAppBar(getTranslated(context, 'CUSTOMER_SUPPORT')!, context),
      floatingActionButton: AnimatedOpacity(
        child: FloatingActionButton(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.fontColor,
            ),
          ),
          onPressed: () async {
            setState(() {
              edit = false;
              show = !show;

              clearAll();
            });
          },
          heroTag: null,
        ),
        duration: Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1 : 0,
      ),
      body: _isNetworkAvail
          ? _isLoading
              ? shimmer(context)
              : Stack(children: [
                  SingleChildScrollView(
                      controller: controller,
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            show
                                ? Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          setType(),
                                          setEmail(),
                                          setTitle(),
                                          setDesc(),
                                          UploadImage(),
                                          Row(
                                            children: [
                                              edit
                                                  ? statusDropDown()
                                                  : Container(),
                                              Spacer(),
                                              sendButton(

                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                : Container(),
                            ticketList.length > 0
                                ? ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: (offset < total)
                                        ? ticketList.length + 1
                                        : ticketList.length,
                                    itemBuilder: (context, index) {

                                        return (index == ticketList.length &&
                                              isLoadingmore)
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ticketItem(index);


                                    })
                                : Container(
                                    height: deviceHeight! -
                                        kToolbarHeight -
                                        MediaQuery.of(context).padding.top,
                                    child: getNoItem(context)),

                          ],
                        ),
                      )),
                  showCircularProgress(_isProgress, colors.primary),
                ])
          : noInternet(context),
    );
  }

  Widget setType() {
    return DropdownButtonFormField(
      iconEnabledColor: Theme.of(context).colorScheme.fontColor,
      isDense: true,
      hint: new Text(
        getTranslated(context, 'SELECT_TYPE')!,
        style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: Theme.of(context).colorScheme.lightWhite,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.fontColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.lightWhite),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: type,
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: Theme.of(context).colorScheme.fontColor),
      onChanged: (String? newValue) {
        if (mounted)
          setState(() {
            type = newValue;
          });
      },
      items: typeList.map((Model user) {
        return DropdownMenuItem<String>(
          value: user.id,
          child: Text(
            user.title!,
          ),
        );
      }).toList(),
    );
  }

  void validateAndSubmit() async {
    if (type == null)
      setSnackbar('Please Select Type');
    else if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
        // sendRequest();
       // sendRequest1();
      sendNewRequest();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
        await buttonController.reverse();
      });
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  setEmail() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        controller: emailController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        validator: (val) => validateEmail(
            val!,
            getTranslated(context, 'EMAIL_REQUIRED'),
            getTranslated(context, 'VALID_EMAIL')),
        onSaved: (String? value) {
          email = value;
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, emailFocus!, nameFocus);
        },
        decoration: InputDecoration(
          hintText: getTranslated(context, 'EMAILHINT_LBL'),
          hintStyle: Theme.of(this.context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          filled: true,
          fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.lightWhite),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  setTitle() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
      ),
      child: TextFormField(
        focusNode: nameFocus,
        textInputAction: TextInputAction.next,
        controller: nameController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        validator: (val) =>
            validateField(val!, getTranslated(context, 'FIELD_REQUIRED')),
        onSaved: (String? value) {
          title = value;
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, emailFocus!, nameFocus);
        },
        decoration: InputDecoration(
          hintText: getTranslated(context, 'TITLE'),
          hintStyle: Theme.of(this.context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          filled: true,
          fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.lightWhite),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  setDesc() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
      ),
      child: TextFormField(
        focusNode: descFocus,
        controller: descController,
        maxLines: null,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        validator: (val) =>
            validateField(val!, getTranslated(context, 'FIELD_REQUIRED')),
        onSaved: (String? value) {
          desc = value;
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, emailFocus!, nameFocus);
        },
        decoration: InputDecoration(
          hintText: getTranslated(context, 'DESCRIPTION'),
          hintStyle: Theme.of(this.context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          filled: true,
          fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.lightWhite),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
  // uploadImages(){
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 5.0, bottom: 5),
  //         child: Text("Images",
  //           style: TextStyle(
  //               fontSize: 15,
  //               color: colors.primary
  //           ),),
  //       ),
  //       imageAadhar(),
  //     ],
  //   );
  // }


  Widget UploadImage(){
    return  Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
           /* var _image =
            await ImagePicker.platform.pickImage(source: ImageSource.camera);
            print(_image!.path);
            addImage(_image);*/
            uploadAadharFromCamOrGallary(context);

          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  color:colors.primary,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("Upload Images")),
            ),
          ),
        ),



        // MaterialButton(
        //   child: Text("Add Image:  ${imageList.length}"),
        //   onPressed: () async {
        //     var _image =
        //     await ImagePicker.platform.pickImage(source: ImageSource.camera);
        //     print(_image!.path);
        //     addImage(_image);
        //   },
        // ),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    //return null;
                    if(selectedImageList.contains(imageList[index].path)){
                      setState((){
                        selectedImageList.remove(imageList[index].path);
                      });
                      print("selected removed ${selectedImageList.length}");
                    }else{
                      setState(() {
                        selectedImageList.add(imageList[index].path);
                      });
                      print("selected add ${selectedImageList.length}");
                    }
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: 14,right: 14),
                    child: Row(
                      children: [
                        Container(
                            height:25,
                            width: 25,
                            alignment: Alignment.center,
                            //padding: EdgeInsets.all(5),
                            decoration:BoxDecoration(
                                border: Border.all(
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.circular(3)
                            ),
                            child:  selectedImageList.contains(imageList[index].path) ? Center(child: Icon(Icons.check)) : Container()
                        ),
                        Card(
                          child:
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                width:250,
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.file(File(imageList[index].path),fit: BoxFit.fill,)
                                ),
                              ),
                              Positioned(
                                right: 2,
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      imageCache.clear();
                                      imageList.clear();
                                     /* selectedImageList.remove(imageList[index].path);
                                      imageList[index].path =null;*/
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: colors.primary
                                      ),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 10,right: 10),
                                      child: Icon(Icons.clear,color: colors.blackTemp,)),
                                ),
                              )
                            ],

                          ),
                        ),
                      ],
                    ),
                  ));
            }),
      ],
    );
  }

  uploadAadharFromCamOrGallary(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () async {
              var _image =
              await ImagePicker.platform.pickImage(source: ImageSource.camera);
              print(_image!.path);
              addImage(_image);
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Photo & Video Library",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () async {
              var _image =
                  await ImagePicker.platform.pickImage(source: ImageSource.gallery);
              print(_image!.path);
              addImage(_image);
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
             Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }


  Future<void> getAadharFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        aadharImage =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }

  Future<void> getAadharFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        aadharImage =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }

  void containerForSheet<T>({BuildContext? context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context!,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
  }




 /* Widget imageAadhar() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () {
          uploadAadharFromCamOrGallary(context);
        },
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: aadharImage != null ?
            Stack(
              children: [
                Container(
                    width: double.infinity,
                    child: Image.file(aadharImage!, fit: BoxFit.fill)),
                Align(alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          aadharImage = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 10,right: 10),
                        decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Icon(
                          Icons.clear,color: Colors.white,
                        ),
                      ),
                    ))
              ],
            )
                : Column(
              children: [
                Icon(Icons.person, size: 60),
                Text("Upload Images")
              ],
            ),
          ),
        ),
      ),
    );
  }
  void containerForSheet<T>({BuildContext? context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context!,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
  }
  uploadAadharFromCamOrGallary(BuildContext context) {
    return
      containerForSheet(
      context: context,
      child:
      CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getAadharFromCamera();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Photo & Video Library",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getAadharFromGallery();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
            // Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  Future<void> getAadharFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        aadharImage =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }

  Future<void> getAadharFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        aadharImage =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }*/

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> getType() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        Response response = await post(getTicketTypeApi, headers: headers)
            .timeout(Duration(seconds: timeOut));
        print(getTicketTypeApi.toString());
        print(getTicketTypeApi.toString());

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          typeList = (data as List)
              .map((data) => new Model.fromSupport(data))
              .toList();
        } else {
          setSnackbar(msg!);
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }
  var i;
  var j ;
  Future<void> getTicket() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          USER_ID: CUR_USERID,
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),


        };

        Response response =
            await post(getTicketApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));
        print(getTicketApi.toString());
        print(parameter.toString());
       print("sssssss ${response.body}");
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];
          total = int.parse(getdata["total"]);

          if ((offset) < total) {
            tempList.clear();
            var data = getdata["data"];
            ticketImageData = data;
            tempList = (data as List)
                .map((data) => new Model.fromTicket(data))
                .toList();
            ticketList.addAll(tempList);

            for(i = 0; i<= ticketList[i].image!.length; i++  ) {

              for (j = 0; j <= ticketList[i].image!.length; j++) {
                setState((){
                  images = ticketList[i].image;
                });

              }
            }

            print("templist here ${data[0]['image']}");


            offset = offset + perPage;
          }
        } else {
          if (msg != "Ticket(s) does not exist") setSnackbar(msg!);
          isLoadingmore = false;
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 1.0,
    ));
  }

  Widget sendButton() {
    return SimBtn(
        size: 0.4,
        title: getTranslated(context, 'SEND'),
        onBtnSelected: () {
          validateAndSubmit();
           // aadharImage = null;
        });
  }

  Future<void> sendRequest() async {
    // List? fileDate = aadharImage!.path.split("/data/user/0/com.vezi.user/cache/");
    // print("pppppppapapappappa=====${fileDate[1]} ");
    if (mounted)
      setState(() {
        _isProgress = true;
      });

    try {
      var data = {
        USER_ID: CUR_USERID,
        SUB: title,
        DESC: desc,
        TICKET_TYPE: type,
        EMAIL: email,
        "image": aadharImage == null ? null : aadharImage!.path.toString()


      };
      if (edit) {
        data[TICKET_ID] = id;
        data[STATUS] = status;

      }

      Response response = await post(edit ? editTicketApi : addTicketApi,
              body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));
      print(addTicketApi.toString());
      print(data.toString());
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];
          if (mounted)
            setState(() {
              if (edit)
                ticketList[curEdit] = Model.fromTicket(data[0]);
              else
                ticketList.add(Model.fromTicket(data[0]));
              edit = false;
              _isProgress = false;
              clearAll();
            });
        }
        setSnackbar(msg);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
    }
  }



  Future<void> sendRequest1() async{

    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzEwODI4NTUsImlhdCI6MTY3MTA4MjU1NSwiaXNzIjoiZXNob3AifQ.c-AZjRIhuXxqMsc0T0UfuRozNDJheqd8eE7NE6AUlGw',
      'Cookie': 'ci_session=3a3acb84431b1141e954a2643f473404c8f06e4e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(edit ?"${baseUrl}/edit_ticket":'$baseUrl/add_ticket'));
    if(edit){
      request.fields.addAll(
          {
          'ticket_id': id.toString(),
            'status': status.toString()
          });
    }
    else{
      request.fields.addAll(
          {
            'user_id': ' ${CUR_USERID}',
            'subject': ' ${title}',
            'description': '${desc}',
            'ticket_type_id': '${type}',
            'email': '${email}'
          });
    }

    aadharImage == null ? "" : request.files.add(await http.MultipartFile.fromPath('image', aadharImage!.path.toString()));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      aadharImage = null;
     final  Result = await response.stream.bytesToString();
     clearAll();
     setSnackbar("Ticket added Successfully!");
     // final finalResult = Model.fromTicket(jsonDecode(Result));
      print("FFFFFFFFFFFF${Result}");

     // ticketList.add(finalResult);

    }
    else {
      setSnackbar("msg");
    }

  }

  Future<void> sendNewRequest() async{
    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzEwODI4NTUsImlhdCI6MTY3MTA4MjU1NSwiaXNzIjoiZXNob3AifQ.c-AZjRIhuXxqMsc0T0UfuRozNDJheqd8eE7NE6AUlGw',
      'Cookie': 'ci_session=e18d36378c37302da3a8e264fb41cddf65e0a887'
    };
    var request = http.MultipartRequest('POST', Uri.parse(edit ?"${baseUrl}edit_ticket":'${baseUrl}add_ticket'));
    request.fields.addAll({
      'user_id': ' ${CUR_USERID}',
      'subject': ' ${title}',
      'description': '${desc}',
      'ticket_type_id': '${type}',
      'email': '${email}'
    });

    for(int i = 0;i<selectedImageList.length;i++ ){

      selectedImageList == null ? null: request.files.add(await http.MultipartFile.fromPath('image[]', '${selectedImageList[i].toString()}'));
    }
    // request.files.add(await http.MultipartFile.fromPath('image[]', '/C:/Users/indian 5/Pictures/Screenshots/Screenshot_20221214_042157.png'));
    // request.files.add(await http.MultipartFile.fromPath('image[]', '/C:/Users/indian 5/Pictures/Screenshots/Screenshot_20221214_103058.png'));
    // request.files.add(await http.MultipartFile.fromPath('image[]', '/C:/Users/indian 5/Pictures/Screenshots/Screenshot_20221215_054915.png'));
    request.headers.addAll(headers);
    print("this is new request for customer support  $baseUrl/add_ticket ${request.fields.toString()} and ${request.files.toString()}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState((){
        imageList.clear();
        selectedImageList.clear();
      });
      final  Result = await response.stream.bytesToString();
      clearAll();
      setSnackbar("Ticket added Successfully!");
      // final finalResult = Model.fromTicket(jsonDecode(Result));
      print("FFFFFFFFFFFF${Result}");
    }
    else {
      print(response.reasonPhrase);
    }

  }



  clearAll() {
    type = null;
    email = null;
    title = null;
    desc = null;
    // ticketImageData = null;
    emailController.text = "";
    nameController.text = "";
    descController.text = "";
  }

  Widget ticketItem(int index) {
    Color back;
    String? status = ticketList[index].status;
    //1 -> pending, 2 -> opened, 3 -> resolved, 4 -> closed, 5 -> reopened
    if (status == "1") {
      back = Colors.orange;
      status = "Pending";
    } else if (status == "2") {
      back = Colors.cyan;
      status = "Opened";
    } else if (status == "3") {
      back = Colors.green;
      status = "Resolved";
    } else if (status == "5") {
      back = Colors.cyan;
      status = "Reopen";
    } else {
      back = Colors.red;
      status = "Close";
    }

print("Images hare ------${ticketList[index].image}&& ${ticketList[index].desc}");
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  id: ticketList[index].id,
                  status: ticketList[index].status,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Type : " + ticketList[index].type!),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: back,
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(4.0))),
                    child: Text(
                      status,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.white),
                    ),
                  )
                ],
              ),
              Text(getTranslated(context, "TITLE")! +
                  " : " +
                  ticketList[index].title!),
              Text(
                getTranslated(context, "DESCRIPTION")! +
                    " : " +
                    ticketList[index].desc!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(getTranslated(context, "DATE")! +
                  " : " +
                  ticketList[index].date!),

              ticketImageData![index]['image'] == null || ticketImageData![index]['image'] == "" ? SizedBox.shrink():
                  SizedBox(height: 10,),

             Container(
               child: ListView.builder(
                 shrinkWrap: true,
                 itemCount: ticketImageData![index]['image'].length,
                   itemBuilder: (context, j ){
                 return  Container(
                   height: 150,
                   width: 150,
                   margin: EdgeInsets.only(bottom: 5),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: ClipRRect(
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                       child: Image.network(
                         // images![j].toString()
                         ticketImageData![index]['image'][j].toString()
                         ,fit: BoxFit.fill,)),
                 );
               }),
             )
             ,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    GestureDetector(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(start: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.lightWhite,
                            borderRadius: new BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          child: Text(
                            getTranslated(context, 'EDIT')!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontSize: 11),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            edit = true;
                            show = true;
                            curEdit = index;
                            id = ticketList[index].id;
                            emailController.text = ticketList[index].email!;
                            nameController.text = ticketList[index].title!;
                            descController.text = ticketList[index].desc!;
                            type = ticketList[index].typeId;
                            // ticketImageData = ticketList[index].image
                          });
                        }),
                    GestureDetector(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(start: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.lightWhite,
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(4.0))),
                          child: Text(
                            getTranslated(context, 'CHAT')!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontSize: 11),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chat(
                                  id: ticketList[index].id,
                                  status: ticketList[index].status,
                                ),
                              ));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  statusDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      child: DropdownButtonFormField(
        iconEnabledColor: Theme.of(context).colorScheme.fontColor,
        isDense: true,
        hint: new Text(
          getTranslated(context, 'SELECT_TYPE')!,
          style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
        ),
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.lightWhite),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        value: status,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Theme.of(context).colorScheme.fontColor),
        onChanged: (String? newValue) {
          if (mounted)
            setState(() {
              status = newValue;
            });
        },
        items: statusList.map((Model user) {
          return DropdownMenuItem<String>(
            value: user.id,
            child: Text(
              user.title!,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }
}
