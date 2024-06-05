import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ShimmerEffects {
  Widget profileCardShimmerEffect(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 65,
            ),
            Container(
              height: 100,
              margin: const EdgeInsets.only(left: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundColor: Colors.grey,
                        size: 45,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black,
                          height: 10,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          color: Colors.black,
                          height: 10,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,

                        ),
                        Container(
                          color: Colors.black,
                          height: 10,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.black,
                      height: 10,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      color: Colors.black,
                      height: 10,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      color: Colors.black,
                      height: 10,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.black,
                    height: 10,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: Colors.black,
                    height: 10,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xffD0F9FF), Color(0xffADF0FF)]),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: const Color(0xffADF0FF), width: 1)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const GFAvatar(
                  backgroundImage: AssetImage('assets/images/socials.png'),
                  shape: GFAvatarShape.circle,
                  size: 30,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 25,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 25,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width*0.45,
              color: Colors.black,
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width*0.25,
              color: Colors.black,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget viewProfileShimmer(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GFAvatar(
          shape: GFAvatarShape.circle,
          size: 50,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 16, 0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.black,
                  height: 14,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.black,
                  height: 14,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.black,
                  height: 14,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}