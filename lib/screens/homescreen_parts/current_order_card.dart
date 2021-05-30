import 'package:flutter/material.dart';
import 'package:suvidha_shopkeeper/database/request_database.dart';
import 'package:suvidha_shopkeeper/models/request.dart';

class CurrentOrderCard extends StatefulWidget {
  List<Request> current = [];
  CurrentOrderCard({this.current});

  @override
  _CurrentOrderCardState createState() => _CurrentOrderCardState();
}

class _CurrentOrderCardState extends State<CurrentOrderCard> {
  @override
  Widget build(BuildContext context) {
    return widget.current.length == 0 ? Container(height: 200, child: Center(child: Text('Nothing yet'))) : Card(
      elevation: 2.5,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.current.length,
          itemBuilder: (_, index) {
            List<String> itemName = [];
            List<int> quantity = [];
            widget.current[index].items.forEach((key, value) {
              itemName.add(key);
              quantity.add(value);
            });
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Text(
                                '${DateTime.parse(widget.current[index].requestTime).day}/${DateTime.parse(widget.current[index].requestTime).month}/${DateTime.parse(widget.current[index].requestTime).year}',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w200)),
                            SizedBox(width: 10.0),
                            Text(
                                '${DateTime.parse(widget.current[index].requestTime).hour}:${DateTime.parse(widget.current[index].requestTime).minute}',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w200)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Text(
                                '${DateTime.parse(widget.current[index].acceptTime).add(Duration(minutes: widget.current[index].expectedTime)).difference(DateTime.now()).inMinutes} min. left ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w200)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15),
                      Text('${widget.current[index].customerName}',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w200)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 15),
                      Flexible(
                          flex: 3,
                          child: Text(
                              '${widget.current[index].customerAddress}',
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w200))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      ExpansionTile(
                        title: Text(
                          "Order Summary",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'S. No.',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Items',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Quantity',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: List.generate(itemName.length, (index) {
                                return DataRow(cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text((itemName[index]).toString())),
                                  DataCell(Text((quantity[index]).toString())),
                                ]);
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          RequestDatabase().orderDelivered(
                              widget.current[index].uid, "STATUS_COMPLETED");
                        },
                        child: Text('Order Delivered'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          RequestDatabase().orderDelivered(
                              widget.current[index].uid, "STATUS_REJECTED");
                        },
                        child: Text('Cancel Delivery'),
                      ),
                    ],
                  ),
                ),
                index != (widget.current.length - 1)
                    ? Divider(
                        color: Colors.black,
                        height: 10,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      )
                    : Container(),
              ],
            );
          }),
    );
  }
}
