function BuildUrl($sym, $s, $e)
{
    $sm = ($s.Month) - 1
    $em = ($e.Month) - 1
    # months need to be decremented (yahoo convention)
    $u = "http://chart.finance.yahoo.com/table.csv?s=$sym&a=$sm&b=$($s.Day)&c=$($s.Year)&d=$em&e=$($e.Day)&f=$($e.Year)&g=d&ignore=.csv"
    return $u
}



<#
.Synopsis
   Takes a stock symbol as input and downloads the historical values from yahoo
.DESCRIPTION
   
.EXAMPLE
   @('SIE.DE','AAPL') | Get-Stock
.EXAMPLE
   Ein weiteres Beispiel für die Verwendung dieses Cmdlets
#>
function Get-Stock
{
    [CmdletBinding()]
    [Alias()]
    #[OutputType([int])]
    Param
    (
        # Hilfebeschreibung zu Param1
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$symbols,

        # Start date for values (default: 1.1.2010)
        [Parameter(Mandatory=$false)]
        [DateTime]$startDate
    )

    Begin
    {
        if ($startDate)
        {
            $start = $startDate
        }
        else 
        {
            $start = [System.DateTime]::Parse('2010-01-01')
        }
        $end = [System.DateTime]::Today
    }
    Process
    {
        $url = BuildUrl $symbols $start $end
        wget $url -OutFile "$symbols.csv"

        Write-Host "Wrote output to: $symbols"
    }
    End
    {
    }
}