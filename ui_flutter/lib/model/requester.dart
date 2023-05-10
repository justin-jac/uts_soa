import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchKategori() async {
  var response = await http.get(Uri.parse('http://localhost:8080/kategori'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Error fetching users');
  }
}

Future<List<dynamic>> fetchKeranjang() async {
  var response = await http.get(Uri.parse('http://localhost:8080/keranjang'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Error fetching users');
  }
}

Future<List<dynamic>> fetchProduk() async {
  var response = await http.get(Uri.parse('http://localhost:8080/produk'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Error fetching users');
  }
}

Future<List<dynamic>> fetchCertProduk(String kategori) async {
  var response = await http.get(Uri.parse('http://localhost:8080/produk/kategori/$kategori'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Error fetching users');
  }
}

Future<List<dynamic>> fetchReview(String produk) async {
  var response = await http.get(Uri.parse('http://localhost:8080/review/produk/$produk'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Error fetching users');
  }
}


Future<void> postReview(String produk, String username, String review) async {
  var response = await http.post(
    Uri.parse('http://localhost:8080/review/produk/$produk'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': '$username', 'star': '$review'}),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    // Successful response
    print('Data posted successfully');
  } else {
    // Error handling
    print('Error posting data: ${response.statusCode}');
  }
}

Future<void> deleteReview(String produk, String username) async {
  var response = await http.delete(
    Uri.parse('http://localhost:8080/review/produk/$produk'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': '$username'}),
  );
  // print("$produk, $username");
  if (response.statusCode == 201 || response.statusCode == 200) {
    // Successful response
    print('Data deleted successfully');
  } else {
    // Error handling
    print('Error posting data: ${response.statusCode}');
  }
}

Future<void> deleteKeranjang(String id_pesanan) async {
  var response = await http.delete(
    Uri.parse('http://localhost:8080/keranjang/$id_pesanan'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id_pesanan': '$id_pesanan'}),
  );
  // print("$produk, $username");
  if (response.statusCode == 201 || response.statusCode == 200) {
    // Successful response
    print('Data deleted successfully');
  } else {
    // Error handling
    print('Error posting data: ${response.statusCode}');
  }
}

Future<void> postKeranjang(String produk) async {
  // print(produk);
  var response = await http.post(
    Uri.parse('http://localhost:8080/keranjang'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id_produk': '$produk'}),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    // Successful response
    print('Data posted successfully');
  } else {
    // Error handling
    print('Error posting data: ${response.statusCode}');
  }
}