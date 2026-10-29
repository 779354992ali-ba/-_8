import 'package:flutter/material.dart';
import 'dart:convert';

// نموذج تجريبي لبيانات الشاشة المأخوذة من مشروع المستخدم في Klencod IDE
const String sampleAppJson = '''
{
  "screens": [
    {
      "screen_id": "home_screen",
      "elements": [
        {
          "type": "Text",
          "properties": {
            "content": "مرحباً بك في تطبيقك المصنوع عبر Klencod",
            "font_size": 20,
            "color": "#333333"
          }
        },
        {
          "type": "Button",
          "properties": {
            "text": "اضغط هنا",
            "background_color": "#2196F3",
            "text_color": "#FFFFFF",
            "action_value": "تم الضغط بنجاح!"
          }
        },
        {
          "type": "Image",
          "properties": {
            "image_url": "https://via.placeholder.com/150",
            "height": 150
          }
        }
      ]
    }
  ]
}
''';

class DynamicScreenRenderer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. تحليل بيانات الـ JSON
    final Map<String, dynamic> appData = json.decode(sampleAppJson);
    final List elements = appData['screens'][0]['elements'];

    return Scaffold(
      appBar: AppBar(
        title: Text('معاينة التطبيق - Klencod Sandbox'),
        backgroundColor: Colors.blueAccent,
      ),
      // 2. بناء العناصر ديناميكياً بناءً على ما ورد في الـ JSON
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: elements.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildDynamicElement(elements[index], context),
          );
        },
      ),
    );
  }

  // 3. دالة التوجيه والمطابقة (Factory Method) لتوليد العنصر المناسب
  Widget _buildDynamicElement(Map<String, dynamic> elementData, BuildContext context) {
    String type = elementData['type'];
    Map<String, dynamic> props = elementData['properties'];

    switch (type) {
      case 'Text':
        return Text(
          props['content'] ?? '',
          style: TextStyle(
            fontSize: (props['font_size'] ?? 16).toDouble(),
            color: _parseColor(props['color']),
          ),
          textAlign: TextAlign.center,
        );

      case 'Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _parseColor(props['background_color']),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(props['action_value'] ?? 'تم التفاعل')),
            );
          },
          child: Text(
            props['text'] ?? 'زر',
            style: TextStyle(color: _parseColor(props['text_color'])),
          ),
        );

      case 'Image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            props['image_url'] ?? '',
            height: (props['height'] ?? 100).toDouble(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 100,
              color: Colors.grey[300],
              child: Center(child: Text('خطأ في تحميل الصورة')),
            ),
          ),
        );

      default:
        return SizedBox.shrink(); // عنصر غير معروف
    }
  }

  // دالة مساعدة لتحويل الأكواد اللونية النصية (Hex) إلى كائن Color في Flutter
  Color _parseColor(String? hexColor) {
    if (hexColor == null) return Colors.black;
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.black;
    }
  }
}