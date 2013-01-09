{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving, ViewPatterns #-}
module Main where

import Testing.Shimit
import System.Console.CmdArgs
import Language.C
import Language.C.System.GCC
import Language.C.Analysis
import Data.Map (Map, (!))
import Data.Maybe

data Options = Options { inputFile :: FilePath
                       } deriving (Data, Typeable, Show)

defOpts :: Options
defOpts = Options def

main :: IO ()
main = do
    opts <- cmdArgs defOpts

    parsed <- parseCFile (newGCC "gcc") Nothing [] (inputFile opts)

    case parsed of
      Right ast -> inspect ast
      Left err -> putStrLn $ "ERROR: " ++ show err

inspect :: CTranslUnit -> IO ()
inspect ast = do
  let needed_types = getNeededTypes ast
  let tms = typeMaps ast

  mapM_ print $ catMaybes $ map (dependOnHrds tms) needed_types

dependOnHrds :: (Map SUERef TagDef, Map Ident TypeDef) -> CTypeSpecifier NodeInfo -> Maybe NodeInfo
dependOnHrds (_, gtds) (CTypeDef n _) = let (TypeDef _ _ _ i) = gtds ! n in Just i
dependOnHrds (gts, _) (CSUType (CStruct _ (Just i) _ _ _) _) = Just $ lookupInfoByIdent gts i
dependOnHrds (gts, _) (CEnumType (CEnum (Just i) _ _ _) _) = Just $ lookupInfoByIdent gts i
dependOnHrds _ _ = Nothing

lookupInfoByIdent :: Map SUERef TagDef -> Ident -> NodeInfo
lookupInfoByIdent gts i = let ref = NamedRef i
                          in case gts ! ref of
                               CompDef (CompType _ _ _ _ i') -> i'
                               EnumDef (EnumType _ _ _ i') -> i'
