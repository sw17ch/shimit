{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving #-}
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
  let Right (x,_) = runTrav () $ do
                      a <- analyseAST ast
                      return (gTags a, gTypeDefs a)

  mapM_ print $ catMaybes $ map (dependOnHrds x) needed_types

dependOnHrds :: (Map SUERef TagDef, Map Ident TypeDef) -> CTypeSpecifier NodeInfo -> Maybe NodeInfo
dependOnHrds (_, gtds) (CTypeDef n _) = let (TypeDef _ _ _ i) = gtds ! n
                                        in Just i
dependOnHrds (gts, _) (CSUType (CStruct _ (Just i) _ _ _) _) = let ref = NamedRef i
                                                               in case gts ! ref of
                                                                    (CompDef (CompType _ _ _ _ i')) -> Just i'
                                                                    (EnumDef (EnumType _ _ _ i')) -> Just i'
dependOnHrds (gts, _) (CEnumType (CEnum (Just i) _ _ _) _) = let ref = NamedRef i
                                                             in case gts ! ref of
                                                                  (CompDef (CompType _ _ _ _ i')) -> Just i'
                                                                  (EnumDef (EnumType _ _ _ i')) -> Just i'
dependOnHrds _ _ = Nothing
