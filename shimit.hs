{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving, ViewPatterns #-}
module Main (main) where

import Testing.Shimit
import System.Console.CmdArgs
import Language.C
import Language.C.System.GCC

data Options = Options { inputFile :: FilePath
                       } deriving (Data, Typeable, Show)

defOpts :: Options
defOpts = Options def

main :: IO ()
main = do
    opts <- cmdArgs defOpts

    parsed <- parseCFile (newGCC "gcc") Nothing [] (inputFile opts)

    case parsed of
      Right ast -> print $ getRequiredFiles ast
      Left err -> putStrLn $ "ERROR: " ++ show err

