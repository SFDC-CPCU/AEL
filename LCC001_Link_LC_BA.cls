public class LCC001_Link_LC_BA {

	private static final String PRELEVEMENTAUTO = 'Prélèvement automatique';

	@auraEnabled
	public static String getDataInit(String contratId) {
		System.debug('Debut getDataInit');

		LC001_WrapperDataInit dataReturned = new LC001_WrapperDataInit();
		LC001_WrapperContrat contratReturned = new LC001_WrapperContrat();
		List<LC001_WrapperAdresse> listAdressesReturned = new List<LC001_WrapperAdresse> ();
		List<LC001_WrapperBillingAccount> listBillingAccountReturned = new List<LC001_WrapperBillingAccount> ();
		List<LC001_WrapperLigneContrat> listLigneContratReturned = new List<LC001_WrapperLigneContrat> ();

		//requete contrat
		Contract contrat = [SELECT Id, Name, AccountId, Account.Name, PLS__c, PLS__r.Name, (Select Id, Name, Mandate_pour_payer__c, Billing_Account__c, Recurrent__c, Service__c, Service__r.Name
		                                                                                    from Lignes_de_Contrat__r WHERE Statut_Souscription__c IN('En attente', 'Données manquantes')) from Contract where Id = :contratId];

		System.debug('getDataInit // contrat = ' + contrat);
		contratReturned.nomComptePrincipal = contrat.Account.Name;
		contratReturned.idComptePrincipal = contrat.AccountId;
		contratReturned.id = contrat.id;
		contratReturned.pls = contrat.PLS__r.Name;

		for (Ligne_de_Contrat__c lc : contrat.Lignes_de_Contrat__r) {

			LC001_WrapperLigneContrat ligneContratReturned = new LC001_WrapperLigneContrat();
			ligneContratReturned.id = lc.Id;
			ligneContratReturned.isRecurrent = lc.Recurrent__c;
			ligneContratReturned.numeroLC = lc.Name;
			ligneContratReturned.service = lc.Service__r.Name;
			ligneContratReturned.idCompteMandate = lc.Mandate_pour_payer__c;

			listLigneContratReturned.add(ligneContratReturned);
		}

		contratReturned.listeLigneContrat = listLigneContratReturned;

		String idComptePrincipal = contrat.AccountId;

		//requete Adresse__c
		List<Adresse_du_compte__c> listAdresses = [Select id, Name, Street__c, PostalCode__c, City__c, Country__c, Account__c, Representant_BillTo__c, attention_de__c, ADRComplement__c from Adresse_du_compte__c];

		System.debug('getDataInit // listAdresses = ' + listAdresses);
		for (Adresse_du_compte__c a : listAdresses) {
			LC001_WrapperAdresse adresseReturned = new LC001_WrapperAdresse();
			adresseReturned.id = a.Id;
			adresseReturned.nom = a.Name;
			adresseReturned.compteAssocie = a.Account__c;
			adresseReturned.nomVoie = a.Street__c;
			adresseReturned.codePostal = a.PostalCode__c;
			adresseReturned.commune = a.City__c;
			adresseReturned.attentionDe = a.attention_de__c;
			adresseReturned.sousCouvertDe = a.Representant_BillTo__c;

			listAdressesReturned.add(adresseReturned);
			System.debug('getDataInit // adresseReturned = ' + adresseReturned);
		}

		//requete Billing Account
		List<Zuora__CustomerAccount__c> listBillingAccount = [Select Id, Name, CRMIDduMandatePourPayer3__c, Zuora__Account__c, Adresse_du_compte__c, Zuora__BillToCity__c, Zuora__BillToCountry__c, Zuora__BillToAddress1__c, Zuora__BillToAddress2__c,
		                                                      Zuora__BillToState__c, Zuora__BillToPostalCode__c, NUMRODUPLSPRINCIPAL__c, Groupe__c, Modedereglement__c, Tech_paymentTerm__c, ReferenceCodeService__c, DematerialisationDatedevalidit__c,
		                                                      Dmatrialisation__c, ReferenceEJ__c, dematmail__c, ReferenceCommande__c, SIRETmandatepourpayer__c, Impressionlocale__c, TaxStatus__c, Zuora__TaxExemptCertificateID__c, recurrent__c
		                                                      from Zuora__CustomerAccount__c where Zuora__Account__c = :idComptePrincipal and IsDeleted = false];


		System.debug('getDataInit // listBillingAccount = ' + listBillingAccount);
		for (Zuora__CustomerAccount__c ba : listBillingAccount) {
			LC001_WrapperBillingAccount baReturned = new LC001_WrapperBillingAccount();
			baReturned.idBillingAccount = ba.Id;
			baReturned.comptePrincipal = ba.Zuora__Account__c;
			baReturned.compteMandate = ba.CRMIDduMandatePourPayer3__c;
			baReturned.nomBillingAccount = ba.Name;
			baReturned.adresseLookup = ba.Adresse_du_compte__c;
			baReturned.billCity = ba.Zuora__BillToCity__c;
			baReturned.billCountry = ba.Zuora__BillToCountry__c;
			baReturned.billAdresse1 = ba.Zuora__BillToAddress1__c;
			baReturned.billAdresse2 = ba.Zuora__BillToAddress2__c;
			baReturned.billDepartement = ba.Zuora__BillToState__c;
			baReturned.billCodePostal = ba.Zuora__BillToPostalCode__c;
			baReturned.modePaiement = ba.Modedereglement__c;
			baReturned.delaisPaiement = ba.Tech_paymentTerm__c;
			baReturned.dematRefCodeService = ba.ReferenceCodeService__c;
			baReturned.dematDateValidite = ba.DematerialisationDatedevalidit__c;
			baReturned.dematerialisation = ba.Dmatrialisation__c;
			baReturned.dematRefEJ = ba.ReferenceEJ__c;
			baReturned.dematEmail = ba.dematmail__c;
			baReturned.dematRefCommande = ba.ReferenceCommande__c;
			baReturned.dematSiret = ba.SIRETmandatepourpayer__c;
			baReturned.impressionLocale = ba.Impressionlocale__c;
			baReturned.statutTaxe = ba.TaxStatus__c;
			baReturned.certificatExoneration = ba.Zuora__TaxExemptCertificateID__c;
			baReturned.isRecurrent = ba.recurrent__c;
			baReturned.numeroPls = ba.NUMRODUPLSPRINCIPAL__c;
			baReturned.isGroupe = ba.Groupe__c;

			listBillingAccountReturned.add(baReturned);
		}

		dataReturned.wrapperContrat = contratReturned;
		dataReturned.listWrapperAdresse = listAdressesReturned;
		dataReturned.ListWrapperBillingAccount = listBillingAccountReturned;

		String wrapperJSON = JSON.serializePretty(dataReturned);
		System.debug('Fin getDataInit // dataReturned = ' + dataReturned);
		System.debug('Fin getDataInit // wrapperJSON = ' + wrapperJSON);

		return wrapperJSON;
	}

	@auraEnabled
	public static void upsertBillingAccountAndLC(String listTocreate, String listeWrapperLigneContratToUpdate, String idContrat, String idComptePrincipal, String listeidCMBillAcc, String listIdAdresse) {
		System.debug('TEST WELKIN');
		System.debug('Debut upsertBillingAccount');
		System.debug('#### upsertBillingAccount --  listeLigneContratToUpdate = ' + listeWrapperLigneContratToUpdate);
		System.debug('#### upsertBillingAccount --  listTocreate = ' + listTocreate);

		List<LC001_WrapperMapBAToCreate> listToCreateParsed = new List<LC001_WrapperMapBAToCreate> ();
		List<Zuora__CustomerAccount__c> listBaToCreate = new List<Zuora__CustomerAccount__c> ();
		Set<Zuora__CustomerAccount__c> setBaToCreate = new Set<Zuora__CustomerAccount__c> ();
		List<LC001_WrapperMapLigneContratToCreate> listWrapperLCToUpdate = new List<LC001_WrapperMapLigneContratToCreate> ();
		List<LC001_WrapperLigneContrat> listWrapperIDCMBillAcc = new List<LC001_WrapperLigneContrat> ();
		Map<String, Zuora__CustomerAccount__c> mapIdLcBillingAcc = new Map<String, Zuora__CustomerAccount__c> ();
		Set<Ligne_de_Contrat__c> setLCToUpdate = new Set<Ligne_de_Contrat__c> ();
		Contract contrat = new Contract();
		Map<String, Account> mapIdBACompteMandate = new Map<String, Account> ();
		Map<String, Adresse_du_compte__c> mapIdAdresseAdresse = new Map<String, Adresse_du_compte__c> ();
		Map<String, LC001_WrapperLigneContrat> mapIdLcLc = new Map<String, LC001_WrapperLigneContrat> ();
		Map<String, Zuora__CustomerAccount__c> mapIdZbaZba = new Map<String, Zuora__CustomerAccount__c> ();
		List<String> listIdComtpeMandate = new List<String> ();
		List<String> listIdAdresseParsed = new List<String> ();
		List<Ligne_de_Contrat__c> listLCToUpdate = new List<Ligne_de_Contrat__c> ();

		try {
			listToCreateParsed = (List<LC001_WrapperMapBAToCreate>) System.JSON.deserialize(listTocreate, List<LC001_WrapperMapBAToCreate>.class);
			listWrapperLCToUpdate = (List<LC001_WrapperMapLigneContratToCreate>) System.JSON.deserialize(listeWrapperLigneContratToUpdate, List<LC001_WrapperMapLigneContratToCreate>.class);
			listIdComtpeMandate = (List<String>) System.JSON.deserialize(listeidCMBillAcc, List<String>.class);
			listIdAdresseParsed = (List<String>) System.JSON.deserialize(listIdAdresse, List<String>.class);

		} catch(Exception e) {
			throw new AuraHandledException('Erreur lors du traitement JSON...' + e.getMessage() + ' - ' + listWrapperLCToUpdate + ' - ' + listTocreate);
		}

		system.debug('#### upsertBillingAccount --  idComptePrincipal = ' + idComptePrincipal);
		system.debug('#### upsertBillingAccount -- listToCreateParsed = ' + listToCreateParsed.size());
		system.debug('#### upsertBillingAccount -- listWrapperLCToUpdate = ' + listWrapperLCToUpdate.size());
		system.debug('#### upsertBillingAccount -- listIdComtpeMandate = ' + listIdComtpeMandate);
		system.debug('#### upsertBillingAccount -- listIdAdresseParsed = ' + listIdAdresseParsed);

		try {
			if (listIdComtpeMandate.size() > 0) {
				system.debug('#### upsertBillingAccount --  listIdComtpeMandate Size > 0');
				for (Account compteMandate :[Select Id, Name, Phone, SAP_Code_Tiers_Payeur__c, Referenceclient__c, SIRET__c, N_du_Compte__c, IBAN_anonyme__c, IBAN__c, Numero_de_mandat_SEPA__c, Code_ICS__c from Account where id in :listIdComtpeMandate]) {
					mapIdBACompteMandate.put(compteMandate.Id, compteMandate);
				}
				system.debug('#### upsertBillingAccount --  mapIdBACompteMandate = ' + mapIdBACompteMandate);
			}
			if (listIdAdresseParsed.size() > 0) {
				system.debug('#### upsertBillingAccount --  listIdAdresseParsed Size > 0');
				for (Adresse_du_compte__c ad :[Select Name, Street__c, PostalCode__c, City__c, Country__c, Account__c, Representant_BillTo__c, attention_de__c, ADRComplement__c from Adresse_du_compte__c where id in :listIdAdresseParsed]) {
					mapIdAdresseAdresse.put(ad.Id, ad);
				}
				system.debug('#### upsertBillingAccount --  mapIdAdresseAdresse = ' + mapIdAdresseAdresse);
			}

		} catch(Exception e) {
			throw new AuraHandledException('Erreur de la construction des map ...' + e.getMessage());
		}

		try {
			system.debug('#### upsertBillingAccount --  idContrat = ' + idContrat);
			contrat = [SELECT Id, Name, AccountId, Account.Name, Account.Phone, Account.ShippingAddress, Account.Complement_Adresse__c, Account.shippingPostalCode, Account.shippingCity, Account.shippingCountry, Account.ShippingStreet,
			           Account.SAP_Famille_de_relance__c, Account.N_du_Compte__c, Account.Type, PLS__r.Name, PLS__r.Id, (Select Id, Name, Mandate_pour_payer__c, Billing_Account__c, Recurrent__c, Service__c, Service__r.Name from Lignes_de_Contrat__r)
			           from Contract where Id = :idContrat];

			system.debug('#### upsertBillingAccount --  contrat = ' + contrat);

			List<Ligne_de_Contrat__c> listeLcContrat = contrat.Lignes_de_Contrat__r;

			if (listToCreateParsed != null && listToCreateParsed.size() > 0) {
				system.debug('#### upsertBillingAccount --  listToCreateParsed Size > 0');

				for (LC001_WrapperMapBAToCreate wrapper : listToCreateParsed) {

					Zuora__CustomerAccount__c zBaWrap = wrapper.ba;
					Zuora__CustomerAccount__c zBa = createBA(contrat, idComptePrincipal, zBaWrap, mapIdBACompteMandate, mapIdAdresseAdresse);
					system.debug('#### upsertBillingAccount --  wrapper.id = ' + wrapper.id);

					listBaToCreate.add(zBa);

					mapIdLcBillingAcc.put(wrapper.id, zBa);

				}

				system.debug('#### upsertBillingAccount --  mapIdLcBillingAcc = ' + mapIdLcBillingAcc);
			}
			system.debug('#### upsertBillingAccount --  listBaToCreate = ' + listBaToCreate.size());
			List<Zuora__CustomerAccount__c> noDupes = new List<Zuora__CustomerAccount__c> (new Set<Zuora__CustomerAccount__c> (listBaToCreate));
			system.debug('#### upsertBillingAccount --  noDupes = ' + noDupes);
			system.debug('#### upsertBillingAccount --  noDupes = ' + noDupes.size());

			if (noDupes != null && noDupes.size() != 0) {
				insert noDupes;
			}

		} catch(Exception e) {
			throw new DmlException('Erreur de la création de billing account ...' + e.getMessage());
		}

		try {
			for (Zuora__CustomerAccount__c zbillAcc :[Select Id, Name, CRMIDduMandatePourPayer3__c, Zuora__Account__c, Adresse_du_compte__c, Zuora__BillToCity__c, Zuora__BillToCountry__c, Zuora__BillToAddress1__c, Zuora__BillToAddress2__c, Zuora__BillToState__c,
			     Zuora__BillToPostalCode__c, Zuora__DefaultPaymentMethod__c, Tech_paymentTerm__c, ReferenceCodeService__c, DematerialisationDatedevalidit__c, Dmatrialisation__c, ReferenceEJ__c, dematmail__c, NUMRODUPLSPRINCIPAL__c,
			     ReferenceCommande__c, SIRETmandatepourpayer__c, Impressionlocale__c, TaxStatus__c, Zuora__TaxExemptCertificateID__c, recurrent__c, Modedereglement__c, IsDeleted from Zuora__CustomerAccount__c
			     where Zuora__Account__c = :idComptePrincipal]) {

				mapIdZbaZba.put(zbillAcc.Id, zbillAcc);
				system.debug('#### upsertBillingAccount --  mapIdZbaZba = ' + mapIdZbaZba.get(zbillAcc.Id));
			}

			system.debug('#### upsertBillingAccount --  mapIdZbaZba.size() = ' + mapIdZbaZba.size());


			for (LC001_WrapperMapLigneContratToCreate w : listWrapperLCToUpdate) {
				system.debug('#### upsertBillingAccount --  mapIdLcLc = ' + w.id + ' - ' + w);
				mapIdLcLc.put(w.id, w.lc);
			}
			for (Ligne_de_Contrat__c finalLC :[Select id, Billing_Account__c, contrat__c, Mandate_pour_payer__c from Ligne_de_Contrat__c where contrat__c = :idContrat]) {


				system.debug('#### upsertBillingAccount --  finalLC = ' + finalLC.id);
				system.debug('#### upsertBillingAccount --  mapIdLcLc.get(finalLC.Id) = ' + mapIdLcLc.get(finalLC.Id));

				if (mapIdLcLc.containsKey(finalLC.Id)) {
					system.debug('#### upsertBillingAccount --  mapIdLcLc contient la clé');
					LC001_WrapperLigneContrat wlc = mapIdLcLc.get(finalLC.Id);

					//if(finalLc.Id == wlc.id){
					if ((wlc.idBillingAccount != '' && wlc.idBillingAccount != null) && (wlc.idCompteMandate != '' && wlc.idCompteMandate != null)) {
						system.debug('#### upsertBillingAccount --  Billing Acc et id Compte mandate non vide');
						//finalLC.Id = wlc.id;
						finalLC.Billing_Account__c = wlc.idBillingAccount;
						finalLC.Mandate_pour_payer__c = wlc.idCompteMandate;

						listLCToUpdate.add(finalLc);
					} else {
						system.debug('#### upsertBillingAccount --  Billing Acc et id Compte mandate VIDE');
						//for(String id : mapIdLcBillingAcc.Keyset()){
						//system.debug('#### upsertBillingAccount -- id = ' + id);
						system.debug('#### upsertBillingAccount -- Zuora__CustomerAccount__c = ' + mapIdLcBillingAcc.get(wlc.Id));

						//if(wlc.Id == id){
						Zuora__CustomerAccount__c ba = mapIdLcBillingAcc.get(wlc.Id);
						system.debug('#### upsertBillingAccount -- ba = ' + ba);
						for (String idZac : mapIdZbaZba.KeySet()) {
							Zuora__CustomerAccount__c zBaFromDb = mapIdZbaZba.get(idZac);
							system.debug('#### upsertBillingAccount -- zBaFromDb = ' + zBaFromDb.id);

							/*system.debug('#### upsertBillingAccount --  zBaFromDb.Zuora__Account__c = ' + zBaFromDb.Zuora__Account__c + ' - ba.Zuora__Account__c = ' + ba.Zuora__Account__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.CRMIDduMandatePourPayer3__c = ' + zBaFromDb.CRMIDduMandatePourPayer3__c + ' - ba.CRMIDduMandatePourPayer3__c = ' + ba.CRMIDduMandatePourPayer3__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.Adresse_du_compte__c = ' + zBaFromDb.Adresse_du_compte__c + ' - ba.Adresse_du_compte__c = ' + ba.Adresse_du_compte__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.Dmatrialisation__c = ' + zBaFromDb.Dmatrialisation__c + ' - ba.Dmatrialisation__c = ' + ba.Dmatrialisation__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.recurrent__c = ' + zBaFromDb.recurrent__c + ' - ba.recurrent__c = ' + ba.recurrent__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.Tech_paymentTerm__c = ' + zBaFromDb.Tech_paymentTerm__c + ' - ba.Tech_paymentTerm__c = ' + ba.Tech_paymentTerm__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.Modedereglement__c = ' + zBaFromDb.Modedereglement__c + ' - ba.Modedereglement__c = ' + ba.Modedereglement__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.Impressionlocale__c = ' + zBaFromDb.Impressionlocale__c + ' - ba.Impressionlocale__c = ' + ba.Impressionlocale__c);
							  system.debug('#### upsertBillingAccount --  zBaFromDb.TaxStatus__c = ' + zBaFromDb.TaxStatus__c + ' - ba.TaxStatus__c = ' + ba.TaxStatus__c);*/


							if (zBaFromDb.Zuora__Account__c == ba.Zuora__Account__c && zBaFromDb.CRMIDduMandatePourPayer3__c == ba.CRMIDduMandatePourPayer3__c && zBaFromDb.Adresse_du_compte__c == ba.Adresse_du_compte__c && zBaFromDb.Dmatrialisation__c == ba.Dmatrialisation__c &&
							    zBaFromDb.recurrent__c == ba.recurrent__c && zBaFromDb.Tech_paymentTerm__c == ba.Tech_paymentTerm__c && zBaFromDb.Modedereglement__c == ba.Modedereglement__c && zBaFromDb.Impressionlocale__c == ba.Impressionlocale__c &&
							    zBaFromDb.TaxStatus__c == ba.TaxStatus__c) {
								system.debug('#### upsertBillingAccount --  zac == ba');

								//finalLC.Id = wlc.id;
								finalLC.Billing_Account__c = zBaFromDb.Id;
								finalLC.Mandate_pour_payer__c = zBaFromDb.CRMIDduMandatePourPayer3__c;

								system.debug('#### upsertBillingAccount --  finalLC.Id = ' + finalLC.Id + ' - finalLC.Billing_Account__c = ' + finalLC.Billing_Account__c + ' - finalLC.Mandate_pour_payer__c = ' + finalLC.Mandate_pour_payer__c);
								listLCToUpdate.add(finalLc);
							}
						}
					}
				}

			}

			List<Ligne_de_Contrat__c> noDupes = new List<Ligne_de_Contrat__c> (new Set<Ligne_de_Contrat__c> (listLCToUpdate));

			update noDupes;
		} catch(Exception e) {
			throw new AuraHandledException('Erreur de la mise à jours des lignes de contrat ...' + e.getMessage());
		}
	}

	private static Zuora__CustomerAccount__c createBA(Contract contrat, String idComptePrincipal, Zuora__CustomerAccount__c zBaWrap, Map<String, Account> mapIdBACompteMandate, Map<String, Adresse_du_compte__c> mapIdAdresseAdresse) {
		System.debug(' Debut createBA ');

		Zuora__CustomerAccount__c zBa = new Zuora__CustomerAccount__c();
		system.debug('#### upsertBillingAccount --  zBaWrap = ' + zBaWrap);

		if (contrat != null) {
			if (zBaWrap.recurrent__c) {
				zBa.Name = 'FACT - ' + contrat.Account.Name + ' - ' + (contrat.PLS__r.Name != '' ? contrat.PLS__r.Name : '') + ' - R' /*+ mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Name + 'R'*/;
			} else {
				zBa.Name = 'FACT - ' + contrat.Account.Name + ' - ' + (contrat.PLS__r.Name != '' ? contrat.PLS__r.Name : '') + ' - P' /*+ mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Name + 'P'*/;
			}
			zBa.Sold_To_First_Name__c = contrat.Account.Name;
			zBa.Zuora__SoldToWorkPhone__c = contrat.Account.Phone;
			zBa.Zuora__SoldToAddress1__c = contrat.Account.ShippingStreet;
			zBa.Zuora__SoldToAddress2__c = contrat.Account.Complement_Adresse__c;
			zBa.Zuora__SoldToPostalCode__c = contrat.Account.shippingPostalCode;
			zBa.Zuora__SoldToCity__c = contrat.Account.ShippingCity;
			zBa.PaysClient__c = contrat.Account.ShippingCountry;
			zBa.Famillederelance__c = contrat.Account.SAP_Famille_de_relance__c;
			zBa.NumeroclientCPCU__c = contrat.Account.N_du_Compte__c;
			zBa.Typedactivit__c = contrat.Account.Type;
		}
		zBa.recurrent__c = zBaWrap.recurrent__c;
		zBa.Zuora__Account__c = idComptePrincipal;
		zBa.Adresse_du_compte__c = zBaWrap.Adresse_du_compte__c;
		zBa.CRMIDduMandatePourPayer3__c = zBaWrap.CRMIDduMandatePourPayer3__c;
		zBa.bill_To_first_Name__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Name;
		zBa.Zuora__BillToWorkPhone__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Phone;
		zBa.Referenceclient__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Referenceclient__c;

		zBa.Zuora__BillToAddress1__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Street__c != null ? mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Street__c : '';
		/*+ ' ' + (mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Adresse__r.Cat_voie__c != null ? mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Adresse__r.Cat_voie__c : '')
		  + ' ' + (mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Adresse__r.Nom_de_la_voie__c != null ? mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Adresse__r.Nom_de_la_voie__c : '');*/

		zBa.Zuora__BillToPostalCode__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).PostalCode__c;
		zBa.Zuora__BillToCity__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).City__c;
		zBa.A_l_attention_de_BillTo__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).attention_de__c;
		zBa.Repr_sent_par_BillTo__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Representant_BillTo__c;
		zBa.PaysPayeur__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).Country__c;
		zBa.Zuora__billToAddress2__c = mapIdAdresseAdresse.get(zBaWrap.Adresse_du_compte__c).ADRComplement__c;
		zBa.CodeTiersPayeur__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).SAP_Code_Tiers_Payeur__c;
		zBa.SIRETmandatepourpayer__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).SIRET__c;
		zBa.NumerodumandatpourpayerCPCU__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).N_du_Compte__c;
		zBa.Modedereglement__c = zBaWrap.Modedereglement__c;

		/*system.debug('#### upsertBillingAccount --  zBaWrap.Modedereglement__c = ' + zBaWrap.Modedereglement__c);
		  if(zBaWrap.Modedereglement__c == PRELEVEMENTAUTO){
		 
		  zBa.PrelevementIBAN__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).IBAN__c;
		  zBa.PrelevementCodeICS__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Code_ICS__c;
		  zBa.PrelevNumerodemandatSEPA__c = mapIdBACompteMandate.get(zBaWrap.CRMIDduMandatePourPayer3__c).Numero_de_mandat_SEPA__c;
		  system.debug('#### upsertBillingAccount --  zBa.PrelevementIBAN__c = ' + zBa.PrelevementIBAN__c);
		  system.debug('#### upsertBillingAccount --  zBa.PrelevementCodeICS__c = ' + zBa.PrelevementCodeICS__c);
		  system.debug('#### upsertBillingAccount --  zBa.PrelevNumerodemandatSEPA__c = ' + zBa.PrelevNumerodemandatSEPA__c);
	   }*/

	if (!String.isBlank(zBaWrap.Impressionlocale__c) && zBaWrap.Impressionlocale__c != '--None--') {
		zBa.Impressionlocale__c = zBaWrap.Impressionlocale__c;
	}else{
		zBa.Impressionlocale__c = 'Non';
	}
	zBa.Dmatrialisation__c = zBaWrap.Dmatrialisation__c;
	zBa.Tech_paymentTerm__c = zBaWrap.Tech_paymentTerm__c;
	zBa.SIRETmandatepourpayer__c = zBaWrap.SIRETmandatepourpayer__c;
	zBa.ReferenceCommande__c = zBaWrap.ReferenceCommande__c;
	zBa.ReferenceCodeService__c = zBaWrap.ReferenceCodeService__c;
	zBa.ReferenceEJ__c = zBaWrap.ReferenceEJ__c;
	zBa.DematerialisationDatedevalidit__c = zBaWrap.DematerialisationDatedevalidit__c;
	zBa.dematmail__c = zBaWrap.dematmail__c;
	zBa.TaxStatus__c = zBaWrap.TaxStatus__c;
	zBa.Zuora__TaxExemptStatus__c = zBaWrap.Zuora__TaxExemptStatus__c;
	zBa.Zuora__TaxExemptCertificateID__c = zBaWrap.Zuora__TaxExemptCertificateID__c;
	zBa.Zuora__Batch__c = 'Batch2';
	zBa.Lot_de_facturation__c = 'Batch2';


	system.debug('#### upsertBillingAccount --  zBa = ' + zBa);

	return zBa;

}
}