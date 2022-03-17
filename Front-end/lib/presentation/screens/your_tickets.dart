import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';

class YourTickets extends StatefulWidget {
  @override
  _YourTicketsState createState() => _YourTicketsState();
}

class _YourTicketsState extends State<YourTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your tickets'),
      ),
      body: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) async {
          if (state.id != '') {
            if (state.generateCode) {
              _showSnackBar(
                  context, 'Generating QR code for the ${state.type}');
              context.read<TicketsBloc>().add(GeneratingCode());
              Navigator.pushNamed(context, '/generateCode');
            }
          } else {
            _showSnackBar(context, 'Please buy a ticket first');
            await Future.delayed(Duration(seconds: 2));
            Navigator.pushNamed(context, '/payment');
          }
        },
        child: BlocBuilder<TicketsBloc, TicketsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<TicketsBloc>().add(GenerateCode());
                  },
                  child: Text('Ticket ID: ${state.id}'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
