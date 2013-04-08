//
//  DMAPDecoder.m
//  dpapClient
//
//  Created by Alexander Lehmann on @"byte"8.@"version".@"Container".
//  Copyright (c) 20@"Container" Alexander Lehmann. All rights reserved.
//

#import "DMAPDecoder.h"

@interface DMAPDecoder()

@property(nonatomic, strong) NSData* data;

@end

@implementation DMAPDecoder

- (id)init
{
    self = [super init];
    if (self) {
        decodingInfo = @{
            @"abal" : @{
                @"ID" : @"abal",
                @"NAME" : @"daap.browsealbumlisting",
                @"TYPE" : @"Container"
            },
            @"abar" : @{
                @"ID" : @"abar",
                @"NAME" : @"daap.browseartistlisting",
                @"TYPE" : @"Container"
            },
            @"abcp" : @{
                @"ID" : @"abcp",
                @"NAME" : @"daap.browsecomposerlisting",
                @"TYPE" : @"Container"
            },
            @"abgn" : @{
                @"ID" : @"abgn",
                @"NAME" : @"daap.browsegenrelisting",
                @"TYPE" : @"Container"
            },
            @"abpl" : @{
                @"ID" : @"abpl",
                @"NAME" : @"daap.baseplaylist",
                @"TYPE" : @"byte"
            },
            @"abro" : @{
                @"ID" : @"abro",
                @"NAME" : @"daap.databasebrowse",
                @"TYPE" : @"Container"
            },
            @"adbs" : @{
                @"ID" : @"adbs",
                @"NAME" : @"daap.databasesongs",
                @"TYPE" : @"Container"
            },
            @"aeNV" : @{
                @"ID" : @"aeNV",
                @"NAME" : @"com.apple.itunes.norm-volume",
                @"TYPE" : @"integer"
            },
            @"aeSP" : @{
                @"ID" : @"aeSP",
                @"NAME" : @"com.apple.itunes.smart-playlist",
                @"TYPE" : @"byte"
            },
            @"aply" : @{
                @"ID" : @"aply",
                @"NAME" : @"daap.databaseplaylists",
                @"TYPE" : @"Container"
            },
            @"apro" : @{
                @"ID" : @"apro",
                @"NAME" : @"daap.protocolversion",
                @"TYPE" : @"version"
            },
            @"apso" : @{
                @"ID" : @"apso",
                @"NAME" : @"daap.playlistsongs",
                @"TYPE" : @"Container"
            },
            @"arif" : @{
                @"ID" : @"arif",
                @"NAME" : @"daap.resolveinfo",
                @"TYPE" : @"Container"
            },
            @"arsv" : @{
                @"ID" : @"arsv",
                @"NAME" : @"daap.resolve",
                @"TYPE" : @"Container"
            },
            @"asal" : @{
                @"ID" : @"asal",
                @"NAME" : @"daap.songalbum",
                @"TYPE" : @"string"
            },
            @"asar" : @{
                @"ID" : @"asar",
                @"NAME" : @"daap.songartist",
                @"TYPE" : @"string"
            },
            @"asbr" : @{
                @"ID" : @"asbr",
                @"NAME" : @"daap.songbitrate",
                @"TYPE" : @"short"
            },
            @"asbt" : @{
                @"ID" : @"asbt",
                @"NAME" : @"daap.songbeatsperminute",
                @"TYPE" : @"short"
            },
            @"ascm" : @{
                @"ID" : @"ascm",
                @"NAME" : @"daap.songcomment",
                @"TYPE" : @"string"
            },
            @"asco" : @{
                @"ID" : @"asco",
                @"NAME" : @"daap.songcompilation",
                @"TYPE" : @"byte"
            },
            @"ascp" : @{
                @"ID" : @"ascp",
                @"NAME" : @"daap.songcomposer",
                @"TYPE" : @"string"
            },
            @"asda" : @{
                @"ID" : @"asda",
                @"NAME" : @"daap.songdateadded",
                @"TYPE" : @"date"
            },
            @"asdb" : @{
                @"ID" : @"asdb",
                @"NAME" : @"daap.songdisabled",
                @"TYPE" : @"byte"
            },
            @"asdc" : @{
                @"ID" : @"asdc",
                @"NAME" : @"daap.songdisccount",
                @"TYPE" : @"short"
            },
            @"asdk" : @{
                @"ID" : @"asdk",
                @"NAME" : @"daap.songdatakind",
                @"TYPE" : @"byte"
            },
            @"asdm" : @{
                @"ID" : @"asdm",
                @"NAME" : @"daap.songdatemodified",
                @"TYPE" : @"date"
            },
            @"asdn" : @{
                @"ID" : @"asdn",
                @"NAME" : @"daap.songdiscnumber",
                @"TYPE" : @"short"
            },
            @"asdt" : @{
                @"ID" : @"asdt",
                @"NAME" : @"daap.songdescription",
                @"TYPE" : @"string"
            },
            @"aseq" : @{
                @"ID" : @"aseq",
                @"NAME" : @"daap.songeqpreset",
                @"TYPE" : @"string"
            },
            @"asfm" : @{
                @"ID" : @"asfm",
                @"NAME" : @"daap.songformat",
                @"TYPE" : @"string"
            },
            @"asgn" : @{
                @"ID" : @"asgn",
                @"NAME" : @"daap.songgenre",
                @"TYPE" : @"string"
            },
            @"asrv" : @{
                @"ID" : @"asrv",
                @"NAME" : @"daap.songrelativevolume",
                @"TYPE" : @"byte"
            },
            @"assp" : @{
                @"ID" : @"assp",
                @"NAME" : @"daap.songstoptime",
                @"TYPE" : @"integer"
            },
            @"assr" : @{
                @"ID" : @"assr",
                @"NAME" : @"daap.songsamplerate",
                @"TYPE" : @"integer"
            },
            @"asst" : @{
                @"ID" : @"asst",
                @"NAME" : @"daap.songstarttime",
                @"TYPE" : @"integer"
            },
            @"assz" : @{
                @"ID" : @"assz",
                @"NAME" : @"daap.songsize",
                @"TYPE" : @"integer"
            },
            @"astc" : @{
                @"ID" : @"astc",
                @"NAME" : @"daap.songtrackcount",
                @"TYPE" : @"short"
            },
            @"astm" : @{
                @"ID" : @"astm",
                @"NAME" : @"daap.songtime",
                @"TYPE" : @"integer"
            },
            @"astn" : @{
                @"ID" : @"astn",
                @"NAME" : @"daap.songtracknumber",
                @"TYPE" : @"short"
            },
            @"asul" : @{
                @"ID" : @"asul",
                @"NAME" : @"daap.songdataurl",
                @"TYPE" : @"string"
            },
            @"asur" : @{
                @"ID" : @"asur",
                @"NAME" : @"daap.songuserrating",
                @"TYPE" : @"byte"
            },
            @"asyr" : @{
                @"ID" : @"asyr",
                @"NAME" : @"daap.songyear",
                @"TYPE" : @"short"
            },
            @"avdb" : @{
                @"ID" : @"avdb",
                @"NAME" : @"daap.serverdatabases",
                @"TYPE" : @"Container"
            },
            @"mbcl" : @{
                @"ID" : @"mbcl",
                @"NAME" : @"dmap.bag",
                @"TYPE" : @"Container"
            },
            @"mccr" : @{
                @"ID" : @"mccr",
                @"NAME" : @"dmap.contentcodesresponse",
                @"TYPE" : @"Container"
            },
            @"mcna" : @{
                @"ID" : @"mcna",
                @"NAME" : @"dmap.contentcodesname",
                @"TYPE" : @"string"
            },
            @"mcnm" : @{
                @"ID" : @"mcnm",
                @"NAME" : @"dmap.contentcodesnumber",
                @"TYPE" : @"string"
            },
            @"mcon" : @{
                @"ID" : @"mcon",
                @"NAME" : @"dmap.container",
                @"TYPE" : @"Container"
            },
            @"mctc" : @{
                @"ID" : @"mctc",
                @"NAME" : @"dmap.containercount",
                @"TYPE" : @"integer"
            },
            @"mcti" : @{
                @"ID" : @"mcti",
                @"NAME" : @"dmap.containeritemid",
                @"TYPE" : @"integer"
            },
            @"mcty" : @{
                @"ID" : @"mcty",
                @"NAME" : @"dmap.contentcodestype",
                @"TYPE" : @"short"
            },
            @"mdcl" : @{
                @"ID" : @"mdcl",
                @"NAME" : @"dmap.dictionary",
                @"TYPE" : @"Container"
            },
            @"miid" : @{
                @"ID" : @"miid",
                @"NAME" : @"dmap.itemid",
                @"TYPE" : @"integer"
            },
            @"mikd" : @{
                @"ID" : @"mikd",
                @"NAME" : @"dmap.itemkind",
                @"TYPE" : @"byte"
            },
            @"mimc" : @{
                @"ID" : @"mimc",
                @"NAME" : @"dmap.itemcount",
                @"TYPE" : @"integer"
            },
            @"minm" : @{
                @"ID" : @"minm",
                @"NAME" : @"dmap.itemname",
                @"TYPE" : @"string"
            },
            @"mlcl" : @{
                @"ID" : @"mlcl",
                @"NAME" : @"dmap.listing",
                @"TYPE" : @"Container"
            },
            @"mlid" : @{
                @"ID" : @"mlid",
                @"NAME" : @"dmap.sessionid",
                @"TYPE" : @"integer"
            },
            @"mlit" : @{
                @"ID" : @"mlit",
                @"NAME" : @"dmap.listingitem",
                @"TYPE" : @"Container"
            },
            @"mlog" : @{
                @"ID" : @"mlog",
                @"NAME" : @"dmap.loginresponse",
                @"TYPE" : @"Container"
            },
            @"mpco" : @{
                @"ID" : @"mpco",
                @"NAME" : @"dmap.parentcontainerid",
                @"TYPE" : @"integer"
            },
            @"mper" : @{
                @"ID" : @"mper",
                @"NAME" : @"dmap.persistentid",
                @"TYPE" : @"int64"
            },
            @"mpro" : @{
                @"ID" : @"mpro",
                @"NAME" : @"dmap.protocolversion",
                @"TYPE" : @"version"
            },
            @"mrco" : @{
                @"ID" : @"mrco",
                @"NAME" : @"dmap.returnedcount",
                @"TYPE" : @"integer"
            },
            @"msal" : @{
                @"ID" : @"msal",
                @"NAME" : @"dmap.supportsautologout",
                @"TYPE" : @"byte"
            },
            @"msau" : @{
                @"ID" : @"msau",
                @"NAME" : @"dmap.authenticationmethod",
                @"TYPE" : @"byte"
            },
            @"msbr" : @{
                @"ID" : @"msbr",
                @"NAME" : @"dmap.supportsbrowse",
                @"TYPE" : @"byte"
            },
            @"msdc" : @{
                @"ID" : @"msdc",
                @"NAME" : @"dmap.databasescount",
                @"TYPE" : @"integer"
            },
            @"msex" : @{
                @"ID" : @"msex",
                @"NAME" : @"dmap.supportsextensions",
                @"TYPE" : @"byte"
        },
            @"msix" : @{
                @"ID" : @"msix",
                @"NAME" : @"dmap.supportsindex",
                @"TYPE" : @"byte"
            },
            @"mslr" : @{
                @"ID" : @"mslr",
                @"NAME" : @"dmap.loginrequired",
                @"TYPE" : @"byte"
            },
            @"mspi" : @{
                @"ID" : @"mspi",
                @"NAME" : @"dmap.supportspersistentids",
                @"TYPE" : @"byte"
            },
            @"msqy" : @{
                @"ID" : @"msqy",
                @"NAME" : @"dmap.supportsquery",
                @"TYPE" : @"byte"
            },
            @"msrs" : @{
                @"ID" : @"msrs",
                @"NAME" : @"dmap.supportsresolve",
                @"TYPE" : @"byte"
            },
            @"msrv" : @{
                @"ID" : @"msrv",
                @"NAME" : @"dmap.serverinforesponse",
                @"TYPE" : @"Container"
            },
            @"mstm" : @{
                @"ID" : @"mstm",
                @"NAME" : @"dmap.timeoutinterval",
                @"TYPE" : @"integer"
            },
            @"msts" : @{
                @"ID" : @"msts",
                @"NAME" : @"dmap.statusstring",
                @"TYPE" : @"string"
            },
            @"mstt" : @{
                @"ID" : @"mstt",
                @"NAME" : @"dmap.status",
                @"TYPE" : @"integer"
            },
            @"msup" : @{
                @"ID" : @"msup",
                @"NAME" : @"dmap.supportsupdate",
                @"TYPE" : @"byte"
            },
            @"mtco" : @{
                @"ID" : @"mtco",
                @"NAME" : @"dmap.specifiedtotalcount",
                @"TYPE" : @"integer"
            },
            @"mudl" : @{
                @"ID" : @"mudl",
                @"NAME" : @"dmap.deletedidlisting",
                @"TYPE" : @"Container"
            },
            @"mupd" : @{
                @"ID" : @"mupd",
                @"NAME" : @"dmap.updateresponse",
                @"TYPE" : @"Container"
            },
            @"musr" : @{
                @"ID" : @"musr",
                @"NAME" : @"dmap.serverrevision",
                @"TYPE" : @"integer"
            },
            @"muty" : @{
                @"ID" : @"muty",
                @"NAME" : @"dmap.updatetype",
                @"TYPE" : @"byte"
            },
            @"pasp" : @{
                @"ID" : @"pasp",
                @"NAME" : @"dpap.aspectratio",
                @"TYPE" : @"string"
            },
            @"pfdt" : @{
                @"ID" : @"pfdt",
                @"NAME" : @"dpap.picturedata",
                @"TYPE" : @"pointer"
            },
            @"picd" : @{
                @"ID" : @"picd",
                @"NAME" : @"dpap.creationdate",
                @"TYPE" : @"integer"
            },
            @"pimf" : @{
                @"ID" : @"pimf",
                @"NAME" : @"dpap.imagefilename",
                @"TYPE" : @"string"
            },
            @"ppro" : @{
                @"ID" : @"ppro",
                @"NAME" : @"dpap.protocolversion",
                @"TYPE" : @"version"
            }
        };
    }
    return self;
}

-(NSDictionary*) parseToken:(NSString*) tokenName withData:(NSData*) currentData
{
    NSDictionary* resultValue = @{};
    NSDictionary* tokenInfo = [decodingInfo objectForKey:tokenName];
    if (tokenInfo)
    {
        currentData = [[tokenInfo objectForKey:@"TYPE"] isEqualToString:@"Container"] ? [self parseDmapResponse:currentData] : currentData;
        resultValue = @{
        @"ID" : [tokenInfo objectForKey:@"ID"],
        @"NAME" : [tokenInfo objectForKey:@"NAME"],
        @"TYPE" : [tokenInfo objectForKey:@"TYPE"],
        @"DATA" : currentData
        };
    }
    return resultValue;
}

-(NSArray*) parseDmapResponse:(NSData*) data
{
    NSMutableArray* resultValue = [[NSMutableArray alloc] init];
    UInt64 currentPosition = 0;
    while (currentPosition + 8 < data.length)
    {
        char code[4];
        uint8_t size_a[4];
        [data getBytes:&code range:NSMakeRange(currentPosition, 4)];
        [data getBytes:&size_a range:NSMakeRange(currentPosition+4, 4)];
        UInt64 size = (uint)size_a[0] * 256*256*256 + (uint)size_a[1] * 256*256 + (uint)size_a[2] * 256 + (uint)size_a[3];
        NSString* codeString = [[NSString alloc] initWithBytes:code length:4 encoding:NSASCIIStringEncoding];
        if (currentPosition+8+size <= data.length)
        {
        NSData* subData = [data subdataWithRange:NSMakeRange(currentPosition+8, size)];
        [resultValue addObject:[self parseToken:codeString withData:subData]];
        }
        currentPosition = currentPosition + 8 + size;
    }
    
    return resultValue;
}

@end
