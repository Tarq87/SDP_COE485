import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/update_tickets_bloc/update_tickets_bloc.dart';

class YourTickets extends StatefulWidget {
  @override
  _YourTicketsState createState() => _YourTicketsState();
}

class _YourTicketsState extends State<YourTickets> {
  List<String> ticketsId = <String>[''];
  List<int> ticketsType = <int>[0];
  String status = 'Tap to Update';
  bool updateTicketsOnce = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
        title: Text('your tickets'),
      ),
      body: BlocListener<UpdateTicketsBloc, UpdateTicketsState>(
        listener: (context, state) {
          if (state.requesting) {
            _showSnackBar(context, 'Updating...');
          } else if (state.tickets_updated) {
            ticketsId = state.tickets_id;
            ticketsType = state.tickets_type;
            status = 'Tap to use';
            _showSnackBar(context, 'Tickets Updated');
          } else {}
        },
        child: BlocBuilder<UpdateTicketsBloc, UpdateTicketsState>(
          builder: (context, state) {
            if (state.requesting) {
            } else if (state.tickets_updated) {
              ticketsId = state.tickets_id;
              ticketsType = state.tickets_type;
              status = 'Tap to use';
            } else {}
            return ListView.builder(
              itemCount: ticketsId.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/photos/ticketImage.png"),
                  ),
                  title: Text(
                      'ID:${ticketsId[index]},\nType: ${ticketsType[index]}'),
                  subtitle: Text(
                    status,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        decorationColor: Colors.black54,
                        decorationStyle: TextDecorationStyle.solid),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    if (status == 'Tap to use') {
                      _showMyDialog(context, index);
                    } else {
                      context.read<UpdateTicketsBloc>().add(SendUpdateTickets(
                          username: context.read<Login2Bloc>().state.username));
                      await Future.delayed(Duration(seconds: 2));
                      // Navigator.pushNamed(context, '/payment');
                    }
                  },
                  selected: true,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          context.read<UpdateTicketsBloc>().add(SendUpdateTickets(
              username: context.read<Login2Bloc>().state.username));
        },
        label: Text('Tap to Update'),
        icon: Icon(Icons.update),
      ),

      /*

      
      BlocBuilder<UpdateTicketsBloc, UpdateTicketsState>(
              builder: (context, state) {
                if (updateTicketsOnce) {
                  updateTicketsOnce = false;
                  context.read<UpdateTicketsBloc>().add(SendUpdateTickets(
                      username: context.read<Login2Bloc>().state.username));
                  return Text('Send Update...');
                } else if (state.requesting) {
                  return Text('Requesting...');
                } else if (state.tickets_updated) {
                  ticketsId = state.tickets_id;
                  ticketsType = state.tickets_type;
                  return Text('Tickets Updated');
                } else {
                  return Text('Somthing Went Wrong!');
                }
              },
            ),

            */

      // replace the listview with this chunk
      /*
      BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) async {
          /*
          if (state.id != '') {
            if (state.generateCode) {
              _showSnackBar(
                  context, 'Generating QR code for the ${state.type}');
              context.read<TicketsBloc>().add(GeneratingCode());
              // Navigator.pushNamed(context, '/generateCode');
            }
          } else {
            _showSnackBar(context, 'Please buy a ticket first');
            await Future.delayed(Duration(seconds: 2));
            // Navigator.pushNamed(context, '/payment');
          }
          */
        },
        child: BlocBuilder<TicketsBloc, TicketsState>(
          builder: (context, state) {
            if (state.id != '') {
              ticketsId.add(state.id);
              ticketsType.add(state.type);
            } else {
              ticketsId.add('NoId');
              ticketsType.add('NoType');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  itemCount: ticketsId.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          'Ticket ID: ${ticketsId[index]}, \nTicket type: ${ticketsType[index]}'),
                    );
                  },
                ),
                /*
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                    onSurface: Colors.grey,
                    side: BorderSide(color: Colors.black, width: 1),
                    elevation: 20,
                    minimumSize: Size(150, 50),
                    shadowColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    if (state.id != '') {
                      _showMyDialog(context);
                    } else {
                      _showSnackBar(context, 'Please buy a ticket first');
                      await Future.delayed(Duration(seconds: 2));
                      // Navigator.pushNamed(context, '/payment');
                    }
                  },
                  child: Text(
                      'Ticket ID: ${state.id}, \nTicket type: ${state.type}'),
                ),
                */
              ],
            );
          },
        ),
      ),
      */
    );
  }

  Future<void> _showMyDialog(BuildContext context, int index) async {
    // this assignment is important to generate QR code or open the scanner for the specified ticket in the list by the user >>
    context.read<TicketsBloc>().state.user =
        context.read<Login2Bloc>().state.username;
    context.read<TicketsBloc>().state.id =
        context.read<UpdateTicketsBloc>().state.tickets_id[index];
    context.read<TicketsBloc>().state.type =
        context.read<UpdateTicketsBloc>().state.tickets_type[index];

    context.read<TicketsBloc>().add(
        InitSelectedTicket()); // will initialize some parameters according to the selected ticekt from the list
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext c) {
        // be careful to change c to context
        return AlertDialog(
          title: const Text('Boarding options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('select "Generate" if there is a scanner on the bus'),
                Text('otherwise, select "Scann" to scan the QR code'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Generate'),
              onPressed: () {
                _showSnackBar(context,
                    'Generating QR code'); // for ${context.read<TicketsBloc>().state.type}
                Navigator.of(context).pop();
                context.read<TicketsBloc>().add(GeneratingCode());
                Navigator.pushNamed(context, '/generateCode');
              },
            ),
            TextButton(
              child: const Text('Scan'),
              onPressed: () {
                _showSnackBar(
                    context, 'Openning camera for scanning bus QR code');
                Navigator.of(context).pop();
                context.read<TicketsBloc>().add(GeneratingCode());
                Navigator.pushNamed(context, '/MobileScanner');
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
