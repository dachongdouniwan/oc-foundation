//
//  _push.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wunused-member-function"
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wshadow-ivar"
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wdeprecated"

//  When it marks any one of the init-family methods in a class's declaration, all other initializers are considered "secondary" (to use Apple's terminology) initializers. That is, they should call through to one another designated or secondary initializer until they reach a designated initializer.
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
