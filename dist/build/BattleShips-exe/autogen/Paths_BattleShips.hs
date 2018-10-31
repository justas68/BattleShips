{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_BattleShips (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3\\BattleShips-0.1.0.0-IkQ3voCRHb66HGiskby0vU"
dynlibdir  = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3"
datadir    = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3\\BattleShips-0.1.0.0"
libexecdir = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\BattleShips-0.1.0.0-IkQ3voCRHb66HGiskby0vU\\x86_64-windows-ghc-8.4.3\\BattleShips-0.1.0.0"
sysconfdir = "C:\\Users\\tvari\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "BattleShips_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "BattleShips_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "BattleShips_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "BattleShips_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "BattleShips_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "BattleShips_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
