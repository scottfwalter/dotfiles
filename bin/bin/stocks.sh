#! /bin/zsh

# Function to format the current date in Unix timestamp
get_current_timestamp() {
  date +%s
}

# Function to fetch stock data for a given symbol
fetch_stock_data() {
  local symbol=$1
  local timestamp=$(get_current_timestamp)

  # Fetch data from Yahoo Finance
  curl -s "https://query1.finance.yahoo.com/v8/finance/chart/${symbol}?interval=1d&range=1d" \
    -H "User-Agent: Mozilla/5.0" \
    -H "Accept: application/json" |
    jq -r --arg sym "$symbol" '
            if .chart.result then
                .chart.result[0] as $data |
                if ($data.meta.regularMarketPrice != null) then
                    "\($sym): \($data.meta.regularMarketPrice)"
                else
                    "\($sym): Price not available"
                end
            else
                "\($sym): Error fetching data"
            end'
}

# Main script
# Check if jq is installed
# if ! command -v jq &> /dev/null; then
#     echo "Error: jq is required but not installed."
#     echo "Please install jq first (e.g., 'sudo apt install jq' or 'brew install jq')"
#     exit 1
# fi

# Check if symbols were provided
# if [ $# -eq 0 ]; then
#     echo "Usage: $0 SYMBOL1 SYMBOL2 ..."
#     echo "Example: $0 AAPL MSFT GOOGL"
#     exit 1
# fi

# Process each symbol
# echo "Fetching current stock prices..."
# for symbol in "$@"; do
#     fetch_stock_data "$symbol"
# done

if [ $# -eq 0 ]; then
  stocks=(AAPL DIS GOOGL MSFT NICE)
else
  stocks=("$@")
fi

echo "Fetching current stock prices..."
for stock in $stocks; do
  fetch_stock_data "$stock"
done

