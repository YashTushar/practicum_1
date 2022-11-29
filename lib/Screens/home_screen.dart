import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practicum_1/Icons/Profile_page.dart';
import 'package:practicum_1/Screens/signin_screen.dart';
import '../Icons/Maps_page.dart';
import '../Icons/Search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final CollectionReference _Events =
   FirebaseFirestore.instance.collection('Events');
  int currentIndex = 0;
  final TextEditingController _EventController =TextEditingController();
  final TextEditingController _DateofEventController =TextEditingController();
  @override


  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _EventController,
                  decoration: const InputDecoration(labelText: 'Event'),
                ),
                TextField(
                  controller: _DateofEventController,
                  decoration: const InputDecoration(
                    labelText: 'DateofEvent',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String Event = _EventController.text;
                    final String DateofEvent = (_DateofEventController.text);
                    if (DateofEvent != null) {
                      await _Events.add({"Event": Event, "DateofEvent": DateofEvent});

                      _EventController.text = '';
                      _DateofEventController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );

        });
  }


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _EventController.text = documentSnapshot['Event'];
      _DateofEventController.text = documentSnapshot['DateofEvent'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _EventController,
                  decoration: const InputDecoration(labelText: 'Event'),
                ),
                TextField(
                  controller: _DateofEventController,
                  decoration: const InputDecoration(
                    labelText: 'DateofEvent',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    final String Event = _EventController.text;
                    final String DateofEvent = _DateofEventController.text;
                    if (DateofEvent != null) {

                      await _Events
                          .doc(documentSnapshot!.id)
                          .update({"Event": Event, "DateofEvent": DateofEvent});
                      _EventController.text = '';
                      _DateofEventController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }
   Future<void> _delete(String productId) async {
     await _Events.doc(productId).delete();

     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
         content: Text('You have successfully deleted a product')));
   }


  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _create(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Your Events",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body:StreamBuilder(
        stream: _Events.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
        if (streamSnapshot.hasData){
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context,index){
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(documentSnapshot['Event']),
                  subtitle: Text(documentSnapshot['DateofEvent']),
                 trailing: SizedBox(
                   width: 100,
                   child: Row(
                     children: [
                       IconButton(
                         icon: const Icon(Icons.edit),
                         onPressed: ()=>
                         _update(documentSnapshot),
                       ),
                       IconButton(
                         icon: const Icon(Icons.delete),
                         onPressed: ()=>
                             _delete(documentSnapshot.id),
                       )
                     ],
                   ),
                 ),
                ),
              );
            },
          );
        }
        return const Center(
          child:CircularProgressIndicator(),
        );
        },
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.green,
      selectedItemColor:Colors.white,
      unselectedItemColor: Colors.white70,
      iconSize: 30,
      selectedFontSize: 20,
      unselectedFontSize: 15,
      currentIndex: currentIndex,
        onTap: (index)=>setState(() {
          currentIndex= index;
        }),
        items:  [
          BottomNavigationBarItem(icon:Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon:GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Maps()));
                },
                child: Icon(Icons.map)
            ),
            label: 'Maps',
            backgroundColor: Colors.cyan,

          ),
          BottomNavigationBarItem(icon:Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
