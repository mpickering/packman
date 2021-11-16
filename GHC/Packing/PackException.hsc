{-# LANGUAGE MagicHash, DeriveDataTypeable #-}

{-| 

Module      : GHC.Packing.PackException
Copyright   : (c) Jost Berthold, 2010-2015,
License     : BSD3
Maintainer  : jost.berthold@gmail.com
Stability   : experimental
Portability : no (depends on GHC internals)

Exception type for packman library, using magic constants #include'd
from a C header file shared with the foreign primitive operation code.

'PackException's can occur at Haskell level or in the foreign primop.

All Haskell-level exceptions are cases of invalid data when /reading/
and /deserialising/ 'GHC.Packing.Serialised' data:

* 'P_BinaryMismatch': serialised data were produced by a
different executable (must be the same binary).
* 'P_TypeMismatch': serialised data have the wrong type
* 'P_ParseError': serialised data could not be parsed (from binary or
text format)

The exceptions caused by the foreign primops (return codes) 
indicate errors at the C level. Most of them can occur when
serialising data; the exception is 'P_GARBLED' which indicates that
serialised data is garbled.

-}

module GHC.Packing.PackException
    ( PackException(..)
    , decodeEx
    , isBHExc
    ) where

-- bring in error codes from cbits/Errors.h
#include "Errors.h"

import GHC.Exts
import GHC.Prim
import Control.Exception
import Data.Typeable

-- | Packing exception codes, matching error codes implemented in the
-- runtime system or describing errors which can occur within Haskell.
data PackException =
    -- keep in sync with Errors.h
    P_SUCCESS      -- ^ no error, ==0.
        -- Internal code, should never be seen by users.
        | P_BLACKHOLE    -- ^ RTS: packing hit a blackhole.
        -- Used internally, not passed to users.
        | P_NOBUFFER     -- ^ RTS: buffer too small
        | P_CANNOTPACK  -- ^ RTS: contains closure which cannot be packed (MVar, TVar)
        | P_UNSUPPORTED  -- ^ RTS: contains unsupported closure type (implementation missing)
        | P_IMPOSSIBLE   -- ^ RTS: impossible case (stack frame, message,...RTS bug!)
        | P_GARBLED       -- ^ RTS: corrupted data for deserialisation

        -- Error codes from inside Haskell
        | P_ParseError     -- ^ Haskell: Packet data could not be parsed
        | P_BinaryMismatch -- ^ Haskell: Executable binaries do not match
        | P_TypeMismatch   -- ^ Haskell: Packet data encodes unexpected type
     deriving (Eq, Ord, Typeable)

-- | decodes an 'Int#' to a @'PackException'@. Magic constants are read
-- from file /cbits///Errors.h/.
decodeEx :: Int## -> PackException
decodeEx #{const P_SUCCESS}##     = P_SUCCESS -- unexpected
decodeEx #{const P_BLACKHOLE}##   = P_BLACKHOLE
decodeEx #{const P_NOBUFFER}##    = P_NOBUFFER
decodeEx #{const P_CANNOTPACK}## = P_CANNOTPACK
decodeEx #{const P_UNSUPPORTED}## = P_UNSUPPORTED
decodeEx #{const P_IMPOSSIBLE}##  = P_IMPOSSIBLE
decodeEx #{const P_GARBLED}##     = P_GARBLED
decodeEx #{const P_ParseError}##     = P_ParseError
decodeEx #{const P_BinaryMismatch}## = P_BinaryMismatch
decodeEx #{const P_TypeMismatch}##   = P_TypeMismatch
decodeEx i##  = error $ "Error value " ++ show (I## i##) ++ " not defined!"

instance Show PackException where
    -- keep in sync with Errors.h
    show P_SUCCESS = "No error." -- we do not expect to see this
    show P_BLACKHOLE     = "Packing hit a blackhole"
    show P_NOBUFFER      = "Pack buffer too small"
    show P_CANNOTPACK    = "Data contain a closure that cannot be packed (MVar, TVar)"
    show P_UNSUPPORTED   = "Contains an unsupported closure type (whose implementation is missing)"
    show P_IMPOSSIBLE    = "An impossible case happened (stack frame, message). This is probably a bug."
    show P_GARBLED       = "Garbled data for deserialisation"
    show P_ParseError     = "Packet parse error"
    show P_BinaryMismatch = "Executable binaries do not match"
    show P_TypeMismatch   = "Packet data has unexpected type"

instance Exception PackException

-- | internal: checks if the given code indicates 'P_BLACKHOLE'
isBHExc :: Int## -> Bool
isBHExc #{const P_BLACKHOLE}##   = True
isBHExc e## = False
