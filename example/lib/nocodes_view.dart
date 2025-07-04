import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class NoCodesView extends StatefulWidget {
  @override
  _NoCodesViewState createState() => _NoCodesViewState();
}

class _NoCodesViewState extends State<NoCodesView> {
  List<String> _events = [];
  
  // Separate stream subscriptions for each NoCodes event type
  late StreamSubscription<NoCodesScreenShownEvent> _screenShownStream;
  late StreamSubscription<NoCodesFinishedEvent> _finishedStream;
  late StreamSubscription<NoCodesActionStartedEvent> _actionStartedStream;
  late StreamSubscription<NoCodesActionFailedEvent> _actionFailedStream;
  late StreamSubscription<NoCodesActionFinishedEvent> _actionFinishedStream;
  late StreamSubscription<NoCodesScreenFailedToLoadEvent> _screenFailedToLoadStream;

  @override
  void initState() {
    super.initState();
    _setupNoCodesEventListeners();
  }

  @override
  void dispose() {
    // Dispose all stream subscriptions
    _screenShownStream.cancel();
    _finishedStream.cancel();
    _actionStartedStream.cancel();
    _actionFailedStream.cancel();
    _actionFinishedStream.cancel();
    _screenFailedToLoadStream.cancel();
    super.dispose();
  }

  void _setupNoCodesEventListeners() {
    // Subscribe to separate NoCodes event streams
    _screenShownStream = NoCodes.getSharedInstance().screenShownStream.listen((event) {
      _addEvent('Screen Shown: ${event.payload}');
    });
    
    _finishedStream = NoCodes.getSharedInstance().finishedStream.listen((event) {
      _addEvent('Finished: ${event.payload}');
    });
    
    _actionStartedStream = NoCodes.getSharedInstance().actionStartedStream.listen((event) {
      _addEvent('Action Started: ${event.payload}');
    });
    
    _actionFailedStream = NoCodes.getSharedInstance().actionFailedStream.listen((event) {
      _addEvent('Action Failed: ${event.payload}');
    });
    
    _actionFinishedStream = NoCodes.getSharedInstance().actionFinishedStream.listen((event) {
      _addEvent('Action Finished: ${event.payload}');
    });
    
    _screenFailedToLoadStream = NoCodes.getSharedInstance().screenFailedToLoadStream.listen((event) {
      _addEvent('Screen Failed to Load: ${event.payload}');
      // NoCodes.getSharedInstance().close();
    });
  }

  void _addEvent(String event) {
    setState(() {
      _events.insert(0, '${DateTime.now().toString().substring(11, 19)}: $event');
      if (_events.length > 20) {
        _events.removeLast();
      }
    });
  }

  Future<void> _showScreen() async {
    try {
      // Set presentation style config before showing screen
      final config = NoCodesPresentationConfig(
        animated: true,
        presentationStyle: NoCodesPresentationStyle.push,
      );

      await NoCodes.getSharedInstance().setScreenPresentationConfig(config, contextKey: 'kamo_test');
      _addEvent('Presentation config set');
      
      await NoCodes.getSharedInstance().showScreen('kamo_test');
    } catch (e) {
      print('Error showing screen: $e');
      _addEvent('Error showing screen: $e');
    }
  }

  Future<void> _close() async {
    try {
      await NoCodes.getSharedInstance().close();
    } catch (e) {
      print('Error closing screen: $e');
      _addEvent('Error closing screen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoCodes Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _events.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // NoCodes Controls Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'NoCodes Controls',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _showScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Show Screen'),
                    ),
                    ElevatedButton(
                      onPressed: _close,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Divider(),
          
          // Events Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'NoCodes Event Streams',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: _events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No events received yet.\nTry showing a NoCodes screen.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_events[index]),
                        dense: true,
                        leading: Icon(Icons.event, size: 16),
                      );
                    },
                  ),
          ),
          
          // Event Types Info
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Available Event Streams:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildEventChip('Screen Shown', Colors.green),
                    _buildEventChip('Finished', Colors.blue),
                    _buildEventChip('Action Started', Colors.orange),
                    _buildEventChip('Action Failed', Colors.red),
                    _buildEventChip('Action Finished', Colors.purple),
                    _buildEventChip('Screen Failed', Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }
} 