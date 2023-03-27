import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  //get data
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('person');

  //text field controller
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  //update
  //perhatikan tanda kurung dialam parameter
  _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['nama'];
      _ageController.text = documentSnapshot['age'].toString();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'nama'),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'age'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _user.doc(documentSnapshot!.id).update({
                      'nama': _nameController.text,
                      'age': _ageController.text
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Berhasil di update')));

                    Navigator.pop(context);
                  },
                  child: Text('Update'))
            ],
          ),
        );
      },
    );
  }

  //create
  _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['nama'];
      _ageController.text = documentSnapshot['age'].toString();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'nama'),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'age'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty) {
                      await _user.add({
                        'nama': _nameController.text,
                        'age': _ageController.text
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text(
                              '${_nameController.text} berhasil ditambahkan')));

                      _nameController.text = '';
                      _ageController.text = '';

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Create'))
            ],
          ),
        );
      },
    );
  }

  //delete
  _delete(String userId) async {
    await _user.doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('User successfully deleted ')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _create(),
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('Home Pages'),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: _user.orderBy('age').snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(documentSnapshot['nama']),
                        subtitle: Text(documentSnapshot['age'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => _update(documentSnapshot),
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () => _delete(documentSnapshot.id),
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}

// class Person {
//   addData(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Text('anjay');
//       },
//     );
//   }
// }
