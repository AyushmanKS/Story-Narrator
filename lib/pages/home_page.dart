import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/book.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Story Narrator',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image_search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFfde6d7),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.brown,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFFfde6d7),
                      child: Icon(
                        Icons.send,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
