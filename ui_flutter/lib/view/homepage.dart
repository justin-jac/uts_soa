import 'package:flutter/material.dart';
// import 'keranjang.dart';
import 'produk.dart';
import '../model/requester.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}


class _homepageState extends State<homepage> {
  List<dynamic> _kategori = [];
  List<dynamic> _produk = [];
  String _selectedUser = "";

  void _showProdukScreen() {
    Navigator.of(context).pushNamed('/produk');
  }

  void _showKeranjang() {
    Navigator.of(context).pushNamed('/keranjang');
  }
  
  @override
  void initState() {
    super.initState();
    // Fetch the list of kategori when the widget is first built
    fetchKategori().then((data) {
      setState(() {
        _kategori = data;
      });
    }).catchError((error) {
      // Error fetching kategori
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _getCertProduk() {
    fetchCertProduk(_selectedUser).then((data){
      setState(() {
        _produk = data;
      });
    }).catchError((error) {
      // Error fetching produk
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _addToKeranjang(String idproduk) {
    postKeranjang(idproduk).catchError((error) {
      // Error fetching produk
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('REST API Demo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropDownKategori(),
              SizedBox(height: 16,),
              
              Text('Produk', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 8.0),
              ..._produk.map<Widget>((user) => Card(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.add, semanticLabel: 'Pesan',),
                    onPressed: () {
                      _addToKeranjang(user['id'].toString());
                    },
                  ),
                  title: Text(user['nama_produk']),
                  onTap: () {
                    ProdukScreen.produkName = user['nama_produk'];
                    ProdukScreen.produkid = user['id'].toString();
                    _showProdukScreen();
                  },
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showKeranjang,
        tooltip: "Keranjang",
        child: const Icon(Icons.trolley),
      ),
    );
  }

  DropdownButtonFormField<String> DropDownKategori() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Pilih kategori'),
      value: _selectedUser.isNotEmpty ? _selectedUser : null,
      onChanged: (value) {
        setState(() {
          _selectedUser = value!;
          _getCertProduk();
        });
      },
      items: _kategori.map<DropdownMenuItem<String>>((user) {
        return DropdownMenuItem<String>(
          value: user['id'].toString(),
          child: Text(user['nama_kategori']),
        );
      }).toList(),
    );
  }


}

