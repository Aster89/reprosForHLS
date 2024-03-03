-- main module
import Xmobar

-- 3rd party modules
import XMonad.Hooks.StatusBar.PP (wrap)

-- my modules
import ArchUpdates (ArchUpdates(..))
import Marquee (Marquee(..))
import Utils (withFont)

data KeyLocks = KeyLocks deriving (Read, Show) -- TODO
data ColorPicker = ColorPicker deriving (Read, Show) -- TODO
data Screenshot = Screenshot deriving (Read, Show) -- TODO

main :: IO ()
main = xmobar defaultConfig {
         additionalFonts = [ "Mononoki 11"
                           , "Font Awesome 6 Free Solid 12"
                           , "Font Awesome 6 Brands 12"
                           , "DejaVuSansM Nerd Font Mono 12"
                           , "Noto Color Emoji 12"
                           ]
       , overrideRedirect = False
       , bgColor  = "#1f222d" -- these colors
       , fgColor  = "#f8f8f2" -- should be an input
       , position = BottomSize L 100{- reduce this to put system tray -} 25
       , commands = [ Run $ WeatherX cambridge
                        [ ("clear", earth emoji)
                        , ("sunny", sunny emoji)
                        , ("mostly clear", "🌤")
                        , ("mostly sunny", "🌤")
                        , ("partly sunny", "⛅")
                        , ("fair", "🌑")
                        , ("cloudy","☁")
                        , ("overcast","☁")
                        , ("partly cloudy", "⛅")
                        , ("mostly cloudy", "🌧")
                        , ("considerable cloudiness", "⛈")]
                        [ "--template", "<skyConditionS>" `withFont` 5 ++ " <tempC>°C"
                        , "-L", "0"
                        , "-H", "25"
                        , "--low"   , "lightblue"
                        , "--normal", "#f8f8f2"
                        , "--high"  , "red"
                        ] 36000
                    , Run $ MultiCoreTemp ["-t", thermometer emoji ++ "<max>°C(<maxpc>%)",
                                           "-L", "60", "-H", "80",
                                           "-l", "cyan", "-n", "yellow", "-h", "red",
                                           "--", "--mintemp", "20", "--maxtemp", "100"] 50
                    , Run $ Cpu
                        [ "--template", cpu emoji ++ "<total>%"
                        , "-L", "3"
                        , "-H", "50"
                        , "--normal", "white"
                        , "--high"  , "red"
                        ] 10
                    {-, Run $ Alsa "default" "Master"
                        [ "--template", "<volumestatus>"
                        , "--suffix"  , "True"
                        , "--"
                        , "--on", ""
                        ]
                        -}
                    -- language
                    , Run $ DiskU [("/", disk emoji ++ "<free>(<freep>%)")]
                                  ["-L", "25", "-H", "50", "-l", "red", "-n", "yellow", "-h", "white", "-m", "1"]
                                  20
                    , Run $ Memory ["--template", ram emoji ++ "<usedratio>%"] 10
                    , Run $ BatteryP ["BAT0"]
                                     ["--template", "<acstatus><left>(<timeleft>)",
                                     "--", "-P","-O", plug emoji, "-i", fullbattery emoji, "-o", lowbattery emoji,
                                     "-a", "notify-send -u critical 'Battery running out!!!'",
                                     "-A", "5"] 600 -- define -a option
                    , Run $ Date (unwords [date, time]) "date" 10
                    , Run xMonadLog
                    , Run ArchUpdates
                    , Run $ Marquee "mymarquee" "this is a very long string" 30 1
                    ]
       , sepChar  = "%"
       , alignSep = alignSeps
       , template = unwords [(%) (alias xMonadLog)
                  , return (head alignSeps)
                  , textcenter
                  , return (alignSeps !! 1)
                  , (%) "mymarquee"
                  , rsep
                  , (%) (alias ArchUpdates)
                  , rsep
                  --, "%alsa:default:Master%"
                  --, rsep
                  , "%multicoretemp%"
                  , "%cpu%"
                  , "%memory%"
                  , "%disku%"
                  , "%battery%"
                  , rsep
                  , (%) cambridge
                  , rsep
                  , "%date%"]
       }
       where
         alignSeps = "}{"
         (%) = wrap "%" "%"
         xMonadLog = UnsafeXMonadLog
         textcenter = unwords [tree emoji, "Ciao, Enrico Maria", lemon emoji]
         cambridge = "EGSC"
         date = calendar emoji ++ "%A %F"
         time = watch emoji ++ "%T"
         lsep = "\xe0b1" `withFont` 4 -- 
         rsep = "\xe0b3" `withFont` 4 -- 

-- emojis from https://emojipedia.org/
data Emojis = Emojis { disk :: !String,
                       ram :: !String,
                       cpu :: !String,
                       calendar :: !String,
                       watch :: !String,
                       plug :: !String,
                       fullbattery :: !String,
                       lowbattery :: !String,
                       lemon :: !String,
                       tree :: !String,
                       thermometer :: !String,
                       earth :: !String,
                       sunny :: !String
                       }
emoji = Emojis {
  {-💿-}disk = "\x1f4bf" `withFont` 4,
  {-🐏-}ram = "\x1f40f" `withFont` 4,
  {-🧮-}cpu = "\x1f9ee" `withFont` 4,
  {-📆-}calendar = "\x1f4c6" `withFont` 4,
  {-⌚-}watch = "\x231a" `withFont` 4,
  {-🔌-}plug = "\x1f50c" `withFont` 4,
  {-🔋-}fullbattery = "\x1f50b" `withFont` 4,
  {-🪫-}lowbattery = "\x1faab" `withFont` 4,
  {-🍋-}lemon = "\x1f34b" `withFont` 4,
  {-🌳-}tree = "\x1f333" `withFont` 4,
  {-🌡️-}thermometer = "\x1f321" `withFont` 5,
  {-🌍-}earth = "\x1f30d" `withFont` 4,
  {-☀️-}sunny = "\x2600\xfe0f" `withFont` 5
}
