// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.apilytic.currency.persistence.domain;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.apilytic.currency.persistence.domain.Currency;
import org.apilytic.currency.persistence.domain.CurrencyDataOnDemand;
import org.apilytic.currency.persistence.repository.CurrencyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

privileged aspect CurrencyDataOnDemand_Roo_DataOnDemand {
    
    declare @type: CurrencyDataOnDemand: @Component;
    
    private Random CurrencyDataOnDemand.rnd = new SecureRandom();
    
    private List<Currency> CurrencyDataOnDemand.data;
    
    @Autowired
    CurrencyRepository CurrencyDataOnDemand.currencyRepository;
    
    public Currency CurrencyDataOnDemand.getNewTransientCurrency(int index) {
        Currency obj = new Currency();
        setMessage(obj, index);
        return obj;
    }
    
    public void CurrencyDataOnDemand.setMessage(Currency obj, int index) {
        String message = "message_" + index;
        obj.setMessage(message);
    }
    
    public Currency CurrencyDataOnDemand.getSpecificCurrency(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        Currency obj = data.get(index);
        BigInteger id = obj.getId();
        return currencyRepository.findOne(id);
    }
    
    public Currency CurrencyDataOnDemand.getRandomCurrency() {
        init();
        Currency obj = data.get(rnd.nextInt(data.size()));
        BigInteger id = obj.getId();
        return currencyRepository.findOne(id);
    }
    
    public boolean CurrencyDataOnDemand.modifyCurrency(Currency obj) {
        return false;
    }
    
    public void CurrencyDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = currencyRepository.findAll(new org.springframework.data.domain.PageRequest(from / to, to)).getContent();
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'Currency' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<Currency>();
        for (int i = 0; i < 10; i++) {
            Currency obj = getNewTransientCurrency(i);
            try {
                currencyRepository.save(obj);
            } catch (final ConstraintViolationException e) {
                final StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    final ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
                }
                throw new IllegalStateException(msg.toString(), e);
            }
            data.add(obj);
        }
    }
    
}
