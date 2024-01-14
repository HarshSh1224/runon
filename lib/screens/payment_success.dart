import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess(
      {required this.paymentId,
      required this.date,
      required this.appointmentId,
      required this.name,
      required this.amount,
      required this.fee,
      super.key});

  final String paymentId;
  final DateTime date;
  final String appointmentId;
  final String name;
  final double amount;
  final double fee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Success.",
                style: GoogleFonts.ptSans(
                  fontSize: 37,
                ),
              ),
              Text(
                "Your payment has been successfully processed",
                style: GoogleFonts.ptSansCaption(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _card(context),
              const SizedBox(
                height: 30,
              ),
              _amount(context),
              const SizedBox(
                height: 30,
              ),
              _confirm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirm(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Confirm",
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amount(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Amount",
                style: GoogleFonts.ubuntu(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Text(
                '₹ ${amount.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Fee",
                style: GoogleFonts.ubuntu(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Text(
                '₹ ${fee.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              Text(
                "Total Amount",
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Text(
                '₹ ${(amount + fee).toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _card(context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                _infoRow(context, "Payment Id", paymentId, Icons.key),
                const SizedBox(height: 20),
                _infoRow(context, "Appointment Id", appointmentId, Icons.discount_rounded),
                const SizedBox(height: 20),
                _infoRow(context, "Name", name, Icons.person),
                const SizedBox(height: 20),
                _infoRow(context, "Date and time", DateFormat('EEE, M/d/y').format(date),
                    Icons.calendar_month),
              ],
            )),
      ),
    );
  }

  Widget _infoRow(context, key, value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: GoogleFonts.ptSans(
            color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.7),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: GoogleFonts.ptSans(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
