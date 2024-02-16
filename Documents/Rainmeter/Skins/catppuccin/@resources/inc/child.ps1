function setWindowName {
    $setMedia=1
    $processCount=$RmAPI.Variable("processCount")
    $title=$RmAPI.MeasureStr("mTitle")
    $artist=$RmAPI.MeasureStr("mArtist")
    $player=$RmAPI.VariableStr("player")
    $pOI=$RmAPI.Variable("pinnedApps")
    $RmAPI.Bang("!setVariable mediaAt -1")
    $RmAPI.Bang("!setVariable mediaAtC 0")
    for($i=0; $i -lt $processCount; $i++) {
        $programName=$RmAPI.VariableStr("programName$i")
        $programCount=$RmAPI.Variable("programsCount$i")
        if($programCount -gt 0) {
            for($j=0; $j -lt $programCount; $j++) {
                $RmAPI.Bang("!commandMeasure programOptions$pOI SetVariable|wName0$j$i|ChildWindowName|$i|$j")
                $RmAPI.Bang("!commandMeasure programOptions$pOI SetVariable|handle0$j$i|ChildHandle|$i|$j")
                $wName=$RmAPI.VariableStr("wName0$j$i")
                if((($wName -match "$title|$artist|$player") -or ($programName -match "$player")) -and ($setMedia -eq 1)) {
                    $RmAPI.Bang("!setVariable mediaAt $i")
                    $RmAPI.Bang("!setVariable mediaAtC 0")
                    if($wName -match "$title|$artist|$player") {
                        $RmAPI.Bang("!setVariable mediaAtC $j")
                    }
                    $setMedia=0
                }
                if(($programName -match "explorer") -and ($wName -match "% complete")) {
                    $RmAPI.Bang("!setVariable progAt $i")
                    $RmAPI.Bang("!setVariable progAtC $j")
                    $p=$wName -replace 'Paused - |% complete',''
                    $RmAPI.Bang("!setVariable prog $p")
                }
            }  
        }
    }
}