import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

class databaseHandler{
  static Future<MySqlConnection> makeConnection() async{
    var conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        // password: '',
        db: 'uts_soa',
      ),
    );
    return conn;
  }
}

void main() async {
  final server = await io.serve(handler, 'localhost', 8080);
  print('Server listening on localhost:${server.port}');
}

final app = Router()

..get('/kategori', _getKategori) //mengambil seluruh list kategori

..get('/kategori/<id>', _getCertKategori) //mengambil detail kategori tertentu

..get('/produk', _getProduk) //mengambil seluruh list produk

..get('/produk/kategori/<id>', _getProdukKategori) //mengambil list produk kategori tertentu

..get('/review/produk/<id>', _getReview) //mengambil list review produk tertentu
..post('/review/produk/<id>', _postReview) //mengunggah review ke produk tertentu
..delete('/review/produk/<id>', _deleteReview) //menghapus review tertentu dari produk tertentu

..get('/keranjang', _getKeranjang) //mengambil seluruh list keranjang
..post('/keranjang', _postKeranjang) //mengunggah satu pesanan ke keranjang

..delete('/keranjang/<id>', _deleteKeranjang) //menghapus satu pesanan dari keranjang
;

Future<Response> _getKategori(Request request) async{
  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM kategori');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _getCertKategori(Request request) async{
  final id = request.params['id'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM kategori WHERE `id` = $id');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _getProduk(Request request) async{
  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM produk');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _getProdukKategori(Request request) async{
  final id = request.params['id'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM produk WHERE `id_kategori` = $id');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _getReview(Request request) async{
  final id = request.params['id'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM review WHERE `id_produk` = $id');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _postReview(Request request) async{
  var requestBody = await request.readAsString();
  var jsonBody = jsonDecode(requestBody);
  
  final id = request.params['id'];
  final username = jsonBody['username'];
  final star = jsonBody['star'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('INSERT INTO `review`(`id_produk`, `username`, `star`) VALUES ($id,"$username",$star)');
  await conn.close();
  return Response.ok('Review Added');
}

Future<Response> _deleteReview(Request request) async{
  var requestBody = await request.readAsString();
  var jsonBody = jsonDecode(requestBody);
  
  final id = request.params['id'];
  final username = jsonBody['username'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('DELETE FROM `review` WHERE `id_produk` = $id AND `username` = "$username"');
  await conn.close();
  return Response.ok('Review Deleted');
}

Future<Response> _getKeranjang(Request request) async{
  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('SELECT * FROM keranjang K, produk P WHERE K.id_produk=P.id');
  final list = <Map<String, dynamic>>[];
  for (var row in results) {
    list.add(Map<String, dynamic>.from(row.fields));
  }
  await conn.close();
  return Response.ok(jsonEncode(list));
}

Future<Response> _postKeranjang(Request request) async{
  var requestBody = await request.readAsString();
  var jsonBody = jsonDecode(requestBody);
  
  final id = jsonBody['id_produk'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('INSERT INTO `keranjang`(`id_produk`) VALUES ($id)');
  await conn.close();
  return Response.ok('Item Added');
}

Future<Response> _deleteKeranjang(Request request) async{
  final id = request.params['id'];

  var conn = await databaseHandler.makeConnection();
  
  final results = await conn.query('DELETE FROM `keranjang` WHERE `id_pesanan` = $id');
  await conn.close();
  return Response.ok('Item Deleted');
}

