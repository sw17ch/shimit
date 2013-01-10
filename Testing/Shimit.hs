{-# LANGUAGE DeriveDataTypeable #-}
module Testing.Shimit where

import Data.Generics.Schemes
import Data.List
import Data.Map (Map, (!))
import Data.Maybe
import Language.C
import Language.C.Analysis

getNeededTypes :: CTranslUnit -> [CTypeSpecifier NodeInfo]
getNeededTypes ast = concatMap relevantTypes $ topLevelFunDefs ast

getRequiredFiles :: CTranslUnit -> [String]
getRequiredFiles ast = nub $ catMaybes $ map defPos needed_types
  where
    defPos (CTypeDef n _) = let (TypeDef _ _ _ i) = typedefs ! n in Just $ nodePos i
    defPos (CSUType (CStruct _ (Just i) _ _ _) _) = Just $ nodePos $ infoByIdent i
    defPos (CEnumType (CEnum (Just i) _ _ _) _) = Just $ nodePos $ infoByIdent i
    defPos _ = Nothing

    nodePos = posFile . posOf
    needed_types = getNeededTypes ast
    (tags,typedefs) = typeMaps ast
    infoByIdent i = let ref = NamedRef i
                    in case tags ! ref of
                         CompDef (CompType _ _ _ _ i') -> i'
                         EnumDef (EnumType _ _ _ i') -> i'

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
