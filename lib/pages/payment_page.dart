import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/components/profile_tile.dart';
import 'package:ut_order/components/success.dart';
import 'package:ut_order/models/user.dart';
import 'package:ut_order/pages/notfound.dart';
import '../data/rest_ds.dart';
import 'package:ut_order/models/global_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class PaymentPage extends StatelessWidget {
  static String tag = 'payment';
  @override
  Widget build(BuildContext context) {
    return PaymentView();
  }
}

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {

  dynamic _pickImageError;
  String _retrieveDataError;
  List<Bank> _bank = [];
  String selectedBank = '003';
  static const menuItems = ['Pilih'];
  String _dateValue;
  RestDatasource rs = new RestDatasource();
  final noRekCtrl = TextEditingController();
  final transferCtrl = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  String page = 'konfirmasi';
  Future<File> _imageFile;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';


  @override
  Widget build(BuildContext context) {
    print("list: ${_bank.length}");
    print("selectted bank :${selectedBank}");
    final up = Provider.of<User>(context);
    var wrapFrom;
    if(page == 'konfirmasi'){
      wrapFrom = Column(
        children: <Widget>[
//          Container(
//            color: Colors.white,
//            child: new Center(
//                child: new Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    new Text("Bank Anda: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
//                    new Container(
//                      padding: new EdgeInsets.all(16.0),
//                    ),
//
//                    DropdownButtonHideUnderline(
//                      child: DropdownButton<String>(
//                        hint: Text("Pilih Bank Anda"),
//                        value: null,
//
//                        onChanged: (String newValue) {
//                          setState(() {
//                            selectedBank = newValue;
//                          });
//                          print(selectedBank);
//                        },
//                        items: _bank.map((Bank map) {
//                          return new DropdownMenuItem<String>(
//                            value: map.bankCode,
//                            child: new Text(map.bankName,style: new TextStyle(color: Colors.black)),
//                          );
//                        }).toList(),
//                      ),
//                    ),
//
//                  ],
//                )
//            ),
//          ),
          SizedBox(height: 20,),
          Container(
            padding: new EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Text("No Rekening: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                new Container(
                  padding: new EdgeInsets.all(16.0),
                ),
                TextField(
                  controller: noRekCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'No Rekening & Atas Nama Transfer',
                      contentPadding: EdgeInsets.all(10.0)

                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: new EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Text("Jumlah Transfer: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                new Container(
                  padding: new EdgeInsets.all(16.0),
                ),
                TextField(
                  controller: transferCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Nominal ',
                      contentPadding: EdgeInsets.all(10.0)

                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: new EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ButtonBar(
                  children: <Widget>[

                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: chooseImage,
                      tooltip: "Ambil dari Kamera",
                    ),

                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(15.0),
            child: showImage(),
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.only(left: 10,right: 26.0),
            child: RaisedButton(
              color: Colors.blue,
              child: Text("Konfirmasi Pembayaran",style: TextStyle(color: Colors.white),),
              onPressed: (){

                startUpload(up.token);
              },
            ),
          ),
        ],
      );
    }else if(page == 'success'){
      Container(

        child: wrapFrom = Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Icon(
              Icons.info,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20.0,
            ),
            ProfileTile(
              title: "Pembayaran Berhasil",
              subtitle: "Mohon tunggu proses oleh CS Kami",
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Konfirmasi Top Up"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.only(left: 20),
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            wrapFrom,

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _getFieldsData();
    super.initState();

  }

  void _getFieldsData() async{
      final items = await rs.getBank();
      var fieldListData = items.map<Bank>((json) {
        return Bank.fromJson(json);
      }).toList();
      selectedBank = fieldListData[0].bankName;

      // update widget
      setState(() {
        _bank = fieldListData;
      });

  }


  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<Null> _pickImageFromGallery() async{
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }
  Future<Null> _pickImageFromCamera() async{}

  chooseImage() {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
  startUpload(token) {

    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName,token);
  }

  upload(String fileName, String token) {
    var noRek = noRekCtrl.text;
    var totTrans = transferCtrl.text;
    var data ={
        "image": base64Image,
        "name": fileName,
        "req_file": fileName,
        "req_saldo": totTrans,
        "req_norek": noRek,
        "req_bank": noRek,

    };
    print(token);
    rs.uploadbukti(data,token).then((result) {
      print(result);
      if(result['status']){
        setState(() {
          page = 'success';
        });
      }
      setStatus(result.message);
    }).catchError((error) {
      print(error);
      setStatus(error);
    });
  }
  Widget showImage() {
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpFile = snapshot.data;
          print(tmpFile);
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }









}


