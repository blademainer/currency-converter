package org.apilytic.currency.ingestion.rate.provider;

import java.util.Map;
import java.util.Set;

import org.apilytic.currency.exchange.ExchangeRateBuilder;
import org.apilytic.currency.persistence.domain.CurrencyExchange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Create yahoo query rate from exchange rates.
 * 
 * @author Georgi Lambov
 * @param <ExchangeRate>
 * 
 */
@Service
public class YahooQueryRateBuilder {

	@Autowired
	private ExchangeRateBuilder exchangeRateBuilder;

	public static final String queryRatePattern = "&s=%s%s=X";

	/**
	 * Builds yahoo query rate builder
	 * 
	 * @return
	 */
	public String createQueryRate() {
		exchangeRateBuilder.constructExchageRate();
		Map<String, Set<CurrencyExchange>> rates = exchangeRateBuilder
				.getExchangeRate().getRates();

		StringBuilder sb = new StringBuilder();
		for (String fromCurrency : rates.keySet()) {
			for (CurrencyExchange toCurrency : rates.get(fromCurrency)) {
				sb.append(String.format(queryRatePattern, fromCurrency,
						toCurrency.getTitle()));
			}
		}

		return sb.toString();
	}
}
