import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../model/requester.dart';

class ProdukScreen extends StatefulWidget {
  ProdukScreen({super.key});
  static String produkid = "1";
  static String produkName = "";

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  List<dynamic> _review = [];
  final _usernameController = TextEditingController();
  final _reviewController = TextEditingController();
  double _formProgress = 0;

  @override
  void initState() {
    super.initState();
    fetchReview(ProdukScreen.produkid).then((data){
      setState(() {
        _review = data;
      });
    }).catchError((error) {
      // Error fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }
  
  List<dynamic> _getReview() {
    fetchReview(ProdukScreen.produkid).then((data){
      setState(() {
        _review = data;
      });
    }).catchError((error) {
      // Error fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
    return _review;
  }
  
  void _addReview() {
    postReview(
      ProdukScreen.produkid, 
      _usernameController.text, 
      _reviewController.text,
    ).catchError((error) {
      // Error fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _remove(String username) {
    deleteReview(
      ProdukScreen.produkid, 
      username,
    ).catchError((error) {
      // Error fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _usernameController,
      _reviewController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    if ( _reviewController.value.text == "0"){
      progress -= 0.5;
    }
    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Produk'),
      ),
      body: SingleChildScrollView(
        child: isi(context),
      )
      
    );
  }

  Column isi(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          ProdukScreen.produkName,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        ..._review.map<Widget>((user) => Card(
          child: ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, semanticLabel: 'Delete',),
              onPressed: () {
                setState(() {
                  _remove(user['username']);
                  _review = _getReview();
                });
              },
            ),
            title: Text(user['username']),
            subtitle: Text("Review: " + user['star'].toString()),
          ),
        )),
        LinearProgressIndicator(value: _formProgress,),
        Text('Add Review', style: Theme.of(context).textTheme.headlineSmall),
        Form(
          child: Column(
            children: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberInputWithIncrementDecrement(
                controller: _reviewController,
                min: 1,
                max: 5,
              ),
            ),],
          ),
        ),
        
        TextButton(
          onPressed: () {
            _updateFormProgress();
            print(_formProgress);
            if(_formProgress == 1){
              _addReview();
              setState(() {  
                _usernameController.clear();
                _getReview;
                _review = _getReview();
              });
            } else {
              setState(() {
                // _getReview;
                _review = _getReview();
              });
              null;
            }
          },
          child: const Text('Add Review')
        ),
      ],
    );
  }
}