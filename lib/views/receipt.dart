import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/button.dart';

class Reciept extends StatelessWidget {
  const Reciept({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 0, 0),
                child: Image.asset(
                  'assets/images/ppocket_logo.png',
                  width: 50,
                  height: 50,
                )),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Text(
                  'PPocket',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Hello, Ahmad!',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: 20,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#1',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Colgate',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * .52,
          ),
          const Column(
            children: [
              Text(
                'Qty 1',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs 200',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ]),
        SizedBox(
          height: Get.height * .02,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: 20,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#2',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Colgate',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * .52,
          ),
          const Column(
            children: [
              Text(
                'Qty 1',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs 200',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ]),
        SizedBox(
          height: Get.height * .02,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: 20,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#3',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Colgate',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * .52,
          ),
          const Column(
            children: [
              Text(
                'Qty 1',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs 200',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ]),
        SizedBox(
          height: Get.height * .02,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: 20,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#4',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Colgate',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * .52,
          ),
          const Column(
            children: [
              Text(
                'Qty 1',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs 200',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ]),
        SizedBox(
          height: Get.height * .03,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: Get.width * .44,
              ),
              const Text(
                'Rs 200',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                'Order No',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: Get.width * .38,
              ),
              const Text(
                '#34567890',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .04,
        ),
        ButtonGreen(text: 'Create PDF', onPressed: () {})
      ]),
    ));
  }
}
