/*
 * (C) 2010-2012 ICM UW. All rights reserved.
 */
package pl.edu.icm.coansys.disambiguation.author.features.disambiguators;

import pl.edu.icm.coansys.disambiguation.author.features.Disambiguator;

/**
 * 
 * @author pdendek
 * @version 1.0
 * @since 2012-08-07
 */
public class EmailPrefixDisambiguator extends Disambiguator{

	@Override
	public String getName() {
		return "EmailPrefixFeature";
	}

}