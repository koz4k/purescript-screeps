-- | Corresponds to the Screeps API [Game](http://support.screeps.com/hc/en-us/articles/203016382-Game)
module Screeps.Game where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe)
import Data.StrMap as StrMap

import Screeps.ConstructionSite (ConstructionSite)
import Screeps.Effects (CMD, TICK, TIME)
import Screeps.Types
import Screeps.Flag    (Flag)
import Screeps.FFI     (toMaybe, runThisEffFn0, runThisEffFn1, runThisEffFn2, runThisFn0, runThisFn1, unsafeField)
import Screeps.Market  (Market)
import Screeps.Spawn   (Spawn)
import Screeps.Id

foreign import getGameGlobal :: forall e. Eff (tick :: TICK | e) GameGlobal

type Gcl =
  { level :: Int
  , progress :: Int
  , progressTotal :: Int }

type Cpu =
  { limit :: Int
  , tickLimit :: Int
  , bucket :: Int }

constructionSites :: GameGlobal -> StrMap.StrMap ConstructionSite
constructionSites = unsafeField "constructionSites"

cpu :: GameGlobal -> Cpu
cpu = unsafeField "cpu"

creeps :: GameGlobal -> StrMap.StrMap Creep
creeps = unsafeField "creeps"

flags :: GameGlobal -> StrMap.StrMap Flag
flags = unsafeField "flags"

gcl :: GameGlobal -> Gcl
gcl = unsafeField "gcl"

map :: GameGlobal -> WorldMap
map = unsafeField "map"

market :: GameGlobal -> Market
market = unsafeField "market"

rooms :: GameGlobal -> StrMap.StrMap Room
rooms = unsafeField "rooms"

spawns :: GameGlobal -> StrMap.StrMap Spawn
spawns = unsafeField "spawns"

structures :: GameGlobal -> StrMap.StrMap AnyStructure
structures = unsafeField "structures"

time :: GameGlobal -> Int
time = unsafeField "time"

getUsed :: forall e. GameGlobal -> Eff (time :: TIME | e) Number
getUsed game = runThisEffFn0 "getUsed" (cpu game)

-- | Phase this out - it is unsafe without explicit checking of Id!
getObjectById :: forall a. GameGlobal -> Id a -> Maybe a
getObjectById game id = toMaybe $ runThisFn1 "getObjectById" game id

notify :: forall e. GameGlobal -> String -> Eff (cmd :: CMD | e) Unit
notify game msg = runThisEffFn1 "notify" game msg

notify' :: forall e. GameGlobal -> String -> Int -> Eff (cmd :: CMD | e) Unit
notify' game msg groupInterval = runThisEffFn2 "notify" game msg groupInterval
