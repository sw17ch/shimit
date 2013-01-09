{-# LANGUAGE DeriveDataTypeable #-}
module Testing.Shimit where

import Data.Generics.Schemes
import Data.Map (Map)
import Language.C
import Language.C.Analysis

getNeededTypes :: CTranslUnit -> [CTypeSpecifier NodeInfo]
getNeededTypes ast = concatMap relevantTypes $ topLevelFunDefs ast

-- getRequiredFiles :: CTranslUnit -> [String]
-- getRequiredFiles ast = 
--   where
--     needed_types = getNeededTypes ast
--     (tags,typedefs) = typeMaps ast

typeMaps :: CTranslUnit -> (Map SUERef TagDef, Map Ident TypeDef)
typeMaps ast = case runTrav () (analyseAST ast >>= (\a -> return (gTags a, gTypeDefs a))) of
                 Left err -> error $ "ERROR: " ++ show err
                 Right (maps,_) -> maps

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
