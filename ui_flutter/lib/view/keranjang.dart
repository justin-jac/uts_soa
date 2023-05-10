import 'package:flutter/material.dart';
import '../model/requester.dart';

class KeranjangScreen extends StatefulWidget {
  KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  List<dynamic> _list_produk = [];

  void _getPesanan() {
    fetchKeranjang().then((data) {
      setState(() {
        _list_produk = data;
      });
    }).catchError((error) {
      // Error fetching kategori
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _getPesanan();
  }

  void _removeProduk(String produk) {
    deleteKeranjang( 
      produk,
    ).catchError((error) {
      // Error fetching
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _showProdukScreen() {
    Navigator.of(context).pushNamed('/produk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Keranjang'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._list_produk.map<Widget>((user) => Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.delete, semanticLabel: 'Delete',),
                  onPressed: () {
                    _removeProduk(user['id_pesanan'].toString());
                    _getPesanan();
                  },
                ),
                title: Text(user['nama_produk']),
                // onTap: () {
                //   _showProdukScreen();
                // },
              ),
            )),
          ],
        )
      )
    );
  }
}