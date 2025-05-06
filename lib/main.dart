import 'package:flutter/material.dart';

void main() => runApp(JadwalApp());

class JadwalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JadwalHomePage(),
    );
  }
}
// Untuk menangani perubahan saat menambahkan jadwal //
class JadwalHomePage extends StatefulWidget {
  @override
  _JadwalHomePageState createState() => _JadwalHomePageState();
}

class _JadwalHomePageState extends State<JadwalHomePage> {
  final List<Map<String, String>> _jadwalList = []; // Menyimpan daftar jadwal 

  final TextEditingController _hariController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();

  int? _indexEdit; // null jika tambah, tidak null jika sedang mengedit

  void _tambahAtauUpdateJadwal() {
    if (_hariController.text.isEmpty ||
        _mataKuliahController.text.isEmpty ||
        _jamController.text.isEmpty) return;

    setState(() {
      if (_indexEdit == null) {
        // Tambah
        _jadwalList.add({
          'hari': _hariController.text,
          'kuliah': _mataKuliahController.text,
          'jam': _jamController.text,
        });
      } else {
        // Update
        _jadwalList[_indexEdit!] = {
          'hari': _hariController.text,
          'kuliah': _mataKuliahController.text,
          'jam': _jamController.text,
        };
        _indexEdit = null;
      }

      _hariController.clear();
      _mataKuliahController.clear();
      _jamController.clear();
    });
  }

  void _hapusJadwal(int index) {
    setState(() {
      _jadwalList.removeAt(index);
    });
  }

  void _editJadwal(int index) {
    setState(() {
      _indexEdit = index;
      _hariController.text = _jadwalList[index]['hari']!;
      _mataKuliahController.text = _jadwalList[index]['kuliah']!;
      _jamController.text = _jadwalList[index]['jam']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context); // Deteksi orientasi (potrait/landscape) //
    final isPortrait = media.orientation == Orientation.portrait;
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Kuliah'),
      ),
      body: Column(
        children: [
          // Daftar Jadwal
          Expanded(
            flex: 3,
            child: _jadwalList.isEmpty
                ? Center(child: Text('Belum ada jadwal'))
                : ListView.builder( // Menampilkan daftar jadwal yang ditambahkan //
                    itemCount: _jadwalList.length,
                    itemBuilder: (context, index) {
                      final jadwal = _jadwalList[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Icon(Icons.book),
                          title: Text('${jadwal['kuliah']} (${jadwal['jam']})'),
                          subtitle: Text('Hari: ${jadwal['hari']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _editJadwal(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _hapusJadwal(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Form Input Jadwal
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            width: double.infinity,
            child: isPortrait
                ? Column(
                    children: _buildInputFields(screenWidth),
                  )
                : Row(
                    children: _buildInputFields(screenWidth),
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInputFields(double width) {
    final inputWidth = width > 600 ? 200.0 : width * 0.25;

    return [
      SizedBox(
        width: inputWidth,
        child: TextField( // Input hari, mata kuliah, dan jam //
          controller: _hariController,
          decoration: InputDecoration(labelText: 'Hari'),
        ),
      ),
      SizedBox(height: 10, width: 10),
      SizedBox(
        width: inputWidth,
        child: TextField(
          controller: _mataKuliahController,
          decoration: InputDecoration(labelText: 'Mata Kuliah'),
        ),
      ),
      SizedBox(height: 10, width: 10),
      SizedBox(
        width: inputWidth,
        child: TextField(
          controller: _jamController,
          decoration: InputDecoration(labelText: 'Jam'),
        ),
      ),
      SizedBox(height: 10, width: 10),
      ElevatedButton(
        onPressed: _tambahAtauUpdateJadwal,
        child: Text(_indexEdit == null ? 'Tambah' : 'Update'),
      ),
    ];
  }
}
