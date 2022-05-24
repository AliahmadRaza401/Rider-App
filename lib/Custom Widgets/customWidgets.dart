import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Images/images.dart';

class CustomWidget {
  ////////////////////////////////  AppBar   ////////////////////
  static setAppBar(
    context,
    bool iconstatus,
    String text,
    color,
    fontweight,
    fontfamily,
    fontsize,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      // automaticallyImplyLeading: false,
      elevation: 0.0,
      titleSpacing: 0.0,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
          color: Color(color),
          fontFamily: fontfamily,
          fontSize: fontsize,
        ),
      ),
      leading: iconstatus == true
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 25,
              ),
            )
          : const SizedBox(),
    );
  }

//////////////////////////////// Height  SizedBox   ////////////////////
  static heightSizedBoxWidget(
    height,
  ) {
    return SizedBox(
      height: height,
    );
  }

//////////////////////////////// Width SizedBox   ////////////////////
  static widthSizedBoxWidget(
    width,
  ) {
    return SizedBox(
      width: width,
    );
  }

////////////////////////////////  TextWidget   ////////////////////
  static textWidget(
    String text,
    fontfamily,
    fontSize,
    fontWeignt,
    textcolor,
  ) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontfamily,
        color: Color(textcolor),
        fontSize: fontSize,
        fontWeight: fontWeignt,
      ),
    );
  }

/////////////////////////////// TextWidget with Border //////////////////////
  static textWidgetWithBorder(
    var text
  ) {
    return Container(
      height: 56.h,
      width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xffAEAEB2), width: 1),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 6.w,
      ),
      child: Row(
        children: [
          const Image(image: AssetImage(location)),
          CustomWidget.widthSizedBoxWidget(9.0.w),
          CustomWidget.textWidget(text, 'Encode Sans',
              12.sp, FontWeight.w400, 0xff606060),
        ],
      ),
    );
  }

  //////////////////////////////////// Custom Button With  Arrow   ///////////////////////////
  static customButtonWidget(
    context,
    String _page,
    String text,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, _page);
      },
      child: Container(
          height: 56.h,
          width: 323.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            // color: const Color(0xffCE1A17),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffEAC4C7),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.55),
              ),
            ],
            color: const Color(0xffCE1A17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Encode Sans'),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xffFFFFFF),
              )
            ],
          )),
    );
  }

  //////////////////////////////////// Custom Button With  Arrow   ///////////////////////////
  static customButtonDesignWidget(
    context,
    String text,
  ) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, _page);
      },
      child: Container(
          height: 56.h,
          width: 323.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            // color: const Color(0xffCE1A17),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffEAC4C7),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.55),
              ),
            ],
            color: const Color(0xffCE1A17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Encode Sans'),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xffFFFFFF),
              )
            ],
          )),
    );
  }

  //////////////////////////////////// Custom Button With No Arrow   ///////////////////////////
  static customButtonWithoutArrowWidget(
    context,
    String _page,
    String text,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, _page);
      },
      child: Container(
          height: 56.h,
          width: 323.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            // color: const Color(0xffCE1A17),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffEAC4C7),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.55),
              ),
            ],
            color: const Color(0xffCE1A17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Encode Sans'),
              ),
            ],
          )),
    );
  }
}
