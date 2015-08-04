//
//  AIEnumCollection.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//


typedef enum
{
    GameCardCut,  //0
    GameCardAddFiveSecond, //1
    GameCardAddTenSecond, //2
    GameCardReverse, //3
    GameCardSkip, //4
    GameCardToSixtySecond, //5
    GameCardToThirtySecond, //6
    GameCardToZeroSecond, //7
    GameCardDrawOne, //8
    GameCardDrawTwo, //9
    GameCardTradeHand, //10
    GameCardDoublePlay, //11
    GameCardPop //12
    
} AIGameCardName;

typedef enum {
    fontZapfino,
    fontCourier,
    fontAvenirNextItalic,
    fontAvenirNextUltraLight,
    fontAvenirNextUltraLightItalic,
    fontAvenirBook,
    fontAvenirLight,
    fontTrebuchetMS,
    fontTrebuchetMSBoldItalic,
    fontTrebuchetMSBold,
    fontTrebuchetMSItalic,
    fontHelveticaNeue,
    fontHelveticaNeueItalic,
    fontHelveticaNeueLight,
    fontHelveticaNeueThin
}AIFontFamily;

typedef enum {
    BorderBottom,
    BorderTop,
    BorderLeft,
    BorderRight
} BorderSide;

typedef enum {
    flatUIColorTurqoise,
    flatUIColorGreenSea,
    flatUIColorSunFlower,
    flatUIColorOrange,
    flatUIColorEmerald,
    flatUIColorNephritis,
    flatUIColorCarrot,
    flatUIColorPumpkin,
    flatUIColorPeterRiver,
    flatUIColorBelizeHole,
    flatUIColorAlizarin,
    flatUIColorPomegranate,
    flatUIColorAmethyst,
    flatUIColorWisteria,
    flatUIColorClouds,
    flatUIColorSilver,
    flatUIColorWetAsphalt,
    flatUIColorMidnightBlue,
    flatUIColorConcrete,
    flatUIColorAsbestos
} FlatUIColor;