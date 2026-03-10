import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassListCell extends StatelessWidget {
  const ClassListCell(
    this.keyString,
    this.cellText,
    this.width,
    this.bkgndColor, [
    this.align,
    this.videoLink = '',
    Key? key,
  ]) : super(key: key);

  final String keyString;
  final String cellText;
  final double width;
  final int bkgndColor;
  final String? align;
  final String videoLink;

  @override
  Widget build(BuildContext context) {
    const Alignment right = Alignment.centerRight;
    const Alignment left = Alignment.centerLeft;
    const Alignment center = Alignment.center;
    final key =
        ['Spring', 'Summer1', 'Summer2', 'Fall', 'Winter'].contains(keyString)
        ? const Key('Term Color Cell')
        : null;
    final alignment = align == 'r'
        ? right
        : align == 'l'
        ? left
        : align == 'c'
        ? center
        : AlignmentDirectional.centerStart;
    final boxDecoration = BoxDecoration(
      color: Color(bkgndColor),
      border: Border.all(color: Colors.white, width: 0.5),
    );

    final text = videoLink.isEmpty
        ? Text(
            key: Key('$keyString Cell'),
            cellText,
            style: const TextStyle(color: Color(0xFF00003e), fontSize: 12),
          )
        : InkWell(
            onTap: () async {
              final Uri url = Uri.parse(videoLink);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: const Text(
              'Video',
              key: Key('Video Link Cell'), // Changed key to be unique
              style: TextStyle(
                color: Colors.blue, // Changed color to blue to indicate a link
                decoration:
                    TextDecoration.underline, // Underline to indicate a link
                decorationColor: Colors.blue, // Set underline color to blue
                fontSize: 12,
                height:
                    1.5, // Adjust height to create space between text and underline
              ),
              textHeightBehavior: TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: true,
              ),
            ),
          );
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $cellText.',
      child: Container(
        key: key,
        padding: const EdgeInsets.all(5),
        alignment: alignment,
        width: width,
        decoration: boxDecoration,
        child: text,
      ),
    );
  }
}
