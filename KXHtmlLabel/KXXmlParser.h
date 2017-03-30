// KXXmlParser.h
// Copyright (c) 2016-2017 kxzen ( https://github.com/kxzen/KXHtmlLabel )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef KXmlParser_hpp
#define KXmlParser_hpp

#import <Foundation/Foundation.h>

//#include <string>
//#include <cstdlib>
//#include <cstring>
//#include <vector>
//#include <map>

#import "KXXmlObject.h"


@interface KXXmlParser: NSObject

+(KXXmlObject *_Nullable) parseFromString:(NSString * _Nonnull)s;
+(void) parseFromString:(NSString * _Nonnull)s parent:(KXXmlObject * _Nonnull)parent;

@end


//class KXmlObject{
//public:
//    std::string name;
//    std::string content;
//    std::map<std::string,std::string> attributes;
//    std::vector<KXmlObject> children;
//    int depth;
//    KXmlObject()
//    {
//        depth = 0;
//    }
//};
//
//class KXmlParser{
//private:
//    
//    static std::vector<std::string> closingTags;
//    
//    static bool hasClosingTag(std::string tag);
//    static int findNextOccurrenceOutsideQuote(const std::string& s, int start, const std::string& target, bool caseInsensitive);
//    
//public:
//    
//    KXmlParser()
//    {
//    }
//    
//    static KXmlObject parse(const std::string& s);
//    
//    static KXmlObject parse(const std::string& s, KXmlObject &parent);
//
//};

#endif /* KXmlParser_hpp */
