import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Assets {
  static List<ImageProvider> get backgroundImageProviders {
    return List.generate(
      bgURL.length,
      (i) => CachedNetworkImageProvider(bgURL[i]),
    );
  }

  static const bgURL = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg001_1000x1000.jpeg?alt=media&token=199346a5-fb06-4871-a2e6-3f2ed7f628c1',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg002_1000x1000.jpeg?alt=media&token=2b60a27e-1efa-4b19-9325-7436b0f3d4fc',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg003_1000x1000.jpeg?alt=media&token=4e9d2e6f-b550-4bd6-8a21-7d8e95a169fb',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg004_1000x1000.jpeg?alt=media&token=592ae255-735c-4c94-9b04-a00ae743047c',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg005_1000x1000.jpeg?alt=media&token=16aea7d3-596c-4e80-92e8-acd4c2d4d3b7',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg006_1000x1000.jpeg?alt=media&token=2f95cfc4-38c9-4105-b0f8-150c94758d3a',
  ];

  static const bgPlaceholderHash = [
    'DFEMI3~B5rpx%M_3s8M{xuaK',
    'M1AAExAB00-q~V1SDk0000?vn#~p?vxU4n',
    'M267}#01t7^j0MS}n%j[bajF02~BRjIp={',
    'MvPF1H4.XnaKV[?^n4WFW.aeNHf+VtkWoe',
    'MCI;^i~p004n4o4oD%%M%Mae01WBt8kC%M',
    'MVE{kN~q?b-;xu%MWBIUIUM{%M%MofWBRj',
  ];
}
