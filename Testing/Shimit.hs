{-# LANGUAGE DeriveDataTypeable #-}
module Testing.Shimit where

import Language.C
import Data.Generics.Schemes

getNeededTypes :: CTranslUnit -> [CTypeSpecifier NodeInfo]
getNeededTypes ast = concatMap relevantTypes $ topLevelFunDefs ast

topLevelFunDefs :: CTranslUnit -> [CFunctionDef NodeInfo]
topLevelFunDefs ctu = (listify isCFunDef) ctu
  where
    isCFunDef :: CFunctionDef NodeInfo -> Bool
    isCFunDef _ = True

relevantTypes :: CFunctionDef NodeInfo -> [CTypeSpecifier NodeInfo]
relevantTypes (CFunDef ret declr _ _ _) = concat [ (listify isTypeSpec) ret
                                                 , (listify isTypeSpec) declr ]
  where
    isTypeSpec :: CTypeSpecifier NodeInfo -> Bool
    isTypeSpec _ = True
