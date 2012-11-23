module Stackage.Types
    ( module X
    , module Stackage.Types
    ) where

import           Data.Map             as X (Map)
import           Data.Map             (unionWith)
import           Data.Monoid          (Monoid (..))
import           Data.Set             as X (Set)
import           Data.Version         as X (Version)
import           Distribution.Package as X (PackageIdentifier (..),
                                            PackageName (..))
import           Distribution.Version as X (VersionRange (..))

newtype PackageDB = PackageDB (Map PackageName PackageInfo)
    deriving (Show, Eq, Ord)

instance Monoid PackageDB where
    mempty = PackageDB mempty
    PackageDB x `mappend` PackageDB y =
        PackageDB $ unionWith newest x y
      where
        newest pi1 pi2
            | piVersion pi1 > piVersion pi2 = pi1
            | otherwise = pi2

data PackageInfo = PackageInfo
    { piVersion :: Version
    , piDeps    :: Set PackageName
    }
    deriving (Show, Eq, Ord)

data HaskellPlatform = HaskellPlatform
    { hpcore :: Set PackageIdentifier
    , hplibs :: Set PackageIdentifier
    }
    deriving (Show, Eq, Ord)
instance Monoid HaskellPlatform where
    mempty = HaskellPlatform mempty mempty
    HaskellPlatform a x `mappend` HaskellPlatform b y = HaskellPlatform (mappend a b) (mappend x y)

data InstallInfo = InstallInfo
    { iiCore     :: Set PackageName
    , iiPackages :: Map PackageName Version
    }