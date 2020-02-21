@isTest
public class LCC001_Link_LC_BA_Test {

	@isTest 
	static void testInit() {

		User user = Factory.createUserTest('System Administrator');
		user.BypassRV__c = true;
		update user;

		System.runAs(user) {

			Account acc = Factory.createAccTest('acc');

			Contract contract = Factory.createContractTest(acc.Id);

			Branchement__c br = Factory.createBranchementTest();

			Opportunity opp2 = Factory.createOppDeveloppement(acc.Id);

			PLS__c pls = Factory.createPlsTest(opp2.Id, contract.Id, br.Id);

			Opportunity opp = new Opportunity();
			opp.AccountId = acc.Id;
			opp.Name = 'opp';
			opp.StageName = 'Remise de l\'offre';
			opp.Type = 'Résiliation';
			opp.PLS__c = pls.Id;
			opp.ContractId = contract.Id;
			opp.CloseDate = Date.today();

			insert opp;


			Quote qo = Factory.createQuoteTest(opp.Id);

			opp.SyncedQuoteId = qo.Id;

			update opp;

			Product2 p2 = Factory.createProduct2();

			zqu__ZProduct__c zp = Factory.createZProduct();

			zqu__ProductRatePlan__c prp = Factory.createProductRatePlan(p2.Id, zp.Id, '8adcd9ec6b4f65ef016b661f6dc55240');


			Adresses__c ad = Factory.createAdresseTest('184 rue de bercy', '56');

			Adresse_du_compte__c adc = new Adresse_du_compte__c();
			adc.Account__c = acc.Id;
			//adc.Adresse__c = ad.Id;
			adc.attention_de__c = 'xxx';
			adc.Representant_BillTo__c = 'rrr';

			insert adc;

			Zuora__CustomerAccount__c zba = Factory.createBaTest(adc.Id, acc.Id);

			Ligne_de_Contrat__c lc9 = Factory.createLCRecurrent(contract.Id, prp.Id, zba.Id, p2.Id, null);

			/*Ligne_de_Contrat__c lc1 = new Ligne_de_Contrat__c();
			  Ligne_de_Contrat__c lc2 = new Ligne_de_Contrat__c();
			  Ligne_de_Contrat__c lc3 = new Ligne_de_Contrat__c();
			  Ligne_de_Contrat__c lc4 = new Ligne_de_Contrat__c();
			 
			  lc1.Contrat__c = contract.id;
			 
			  lc2.Contrat__c = contract.id;
			  lc3.Contrat__c = contract.id;
			  lc4.Contrat__c = contract.id;
			 
			  insert lc1;
			  insert lc4;
			  insert lc2;
			  insert lc3;*/

			Test.startTest();

			LCC001_Link_LC_BA.getDataInit(contract.Id);

			Test.stopTest();
		}



	}

	@isTest
	static void testUpsertData() {

		User user = Factory.createUserTest('System Administrator');

		System.runAs(user) {

			Account acc = Factory.createAccTest('acc');
			Account acc2 = Factory.createAccTest('acc2');
			Account acc3 = Factory.createAccTest('acc3');
			Account acc4 = Factory.createAccTest('acc4');

			Adresses__c ad = Factory.createAdresseTest('185 rue de bercy', '51');
			Adresses__c ad2 = Factory.createAdresseTest('186 rue de bercy', '52');
			Adresses__c ad3 = Factory.createAdresseTest('187 rue de bercy', '53');

			Adresse_du_compte__c adc1 = Factory.createAdresseDeCompteTest(acc.Id, ad.Id);
			Adresse_du_compte__c adc2 = Factory.createAdresseDeCompteTest(acc2.Id, ad2.Id);
			Adresse_du_compte__c adc3 = Factory.createAdresseDeCompteTest(acc3.Id, ad3.Id);

			Contract contract = Factory.createContractTest(acc.Id);

			Ligne_de_Contrat__c lc1 = new Ligne_de_Contrat__c();
			Ligne_de_Contrat__c lc2 = new Ligne_de_Contrat__c();
			Ligne_de_Contrat__c lc3 = new Ligne_de_Contrat__c();

			lc1.Contrat__c = contract.id;
			lc2.Contrat__c = contract.id;
			lc3.Contrat__c = contract.id;

			insert lc1;
			insert lc2;
			insert lc3;

			Branchement__c br = Factory.createBranchementTest();

			Opportunity opp2 = Factory.createOppDeveloppement(acc.Id);

			PLS__c pls = Factory.createPlsTest(opp2.Id, contract.Id, br.Id);

			Zuora__CustomerAccount__c zuoraBA = Factory.createBaTest(adc1.Id, acc.Id);

			LC001_WrapperMapBAToCreate wmba = new LC001_WrapperMapBAToCreate();
			wmba.id = lc1.Id;
			wmba.ba = zuoraBA;

			List<LC001_WrapperMapBAToCreate> listwmba = new List<LC001_WrapperMapBAToCreate> ();
			listwmba.add(wmba);

			String listToCreate = JSON.serialize(listwmba);

			LC001_WrapperMapLigneContratToCreate wmlc = new LC001_WrapperMapLigneContratToCreate();
			wmlc.id = lc1.Id;
			LC001_WrapperLigneContrat wlc = new LC001_WrapperLigneContrat();
			wlc.id = lc1.Id;
			wlc.idBillingAccount = '';
			wlc.idCompteMandate = '';
			wlc.isRecurrent = true;
			wlc.service = 'T334 - Consommation estimée d énergie été';
			wlc.numeroLC = 'LC-0000190126';
			wmlc.lc = wlc;

			LC001_WrapperMapLigneContratToCreate wmlc2 = new LC001_WrapperMapLigneContratToCreate();
			wmlc2.id = lc2.Id;
			LC001_WrapperLigneContrat wlc2 = new LC001_WrapperLigneContrat();
			wlc2.id = lc1.Id;
			wlc2.idBillingAccount = zuoraBA.Id;
			wlc2.idCompteMandate = acc2.Id;
			wlc2.isRecurrent = true;
			wlc2.service = 'T334 - Consommation estimée d énergie été';
			wlc2.numeroLC = 'LC-0000190123';
			wmlc2.lc = wlc2;

			LC001_WrapperMapLigneContratToCreate wmlc3 = new LC001_WrapperMapLigneContratToCreate();
			wmlc3.id = lc3.Id;
			LC001_WrapperLigneContrat wlc3 = new LC001_WrapperLigneContrat();
			wlc3.id = lc3.Id;
			wlc3.idBillingAccount = zuoraBA.Id;
			wlc3.idCompteMandate = acc2.Id;
			wlc3.isRecurrent = true;
			wlc3.service = 'T334 - Consommation estimée d énergie été';
			wlc3.numeroLC = 'LC-0000190128';
			wmlc3.lc = wlc3;

			List<LC001_WrapperMapLigneContratToCreate> listwmlc = new List<LC001_WrapperMapLigneContratToCreate> ();
			listwmlc.add(wmlc);
			listwmlc.add(wmlc2);
			listwmlc.add(wmlc3);

			String listeWrapperLigneContratToUpdate = JSON.serialize(listwmlc);

			List<String> listIdAdresse = new List<String> ();
			listIdAdresse.add(adc1.Id);
			listIdAdresse.add(adc2.Id);
			listIdAdresse.add(adc3.Id);

			String listidAd = JSON.serialize(listIdAdresse);
			//'["' + String.valueOf(adc1.Id) + '","' + String.valueOf(adc2.Id) + '","' + String.valueOf(adc3.Id) + '"]';

			List<String> listIdAcc = new List<String> ();
			listIdAcc.add(acc.Id);
			listIdAcc.add(acc2.Id);
			listIdAcc.add(acc3.Id);

			String listWrapperIdCMBA = JSON.serialize(listIdAcc);
			//'["' + String.valueOf(acc.Id) + '","' + String.valueOf(acc2.Id) + '","' + String.valueOf(acc4.Id) + '","' + String.valueOf(acc3.Id) + '"]';

			System.debug('TEST METHOD -- listToCreate = ' + listToCreate);
			System.debug('TEST METHOD -- listeWrapperLigneContratToUpdate = ' + listeWrapperLigneContratToUpdate);
			System.debug('TEST METHOD -- listidAd = ' + listidAd);
			System.debug('TEST METHOD -- listWrapperIdCMBA = ' + listWrapperIdCMBA);

			Test.startTest();

			LCC001_Link_LC_BA.upsertBillingAccountAndLC(listToCreate, listeWrapperLigneContratToUpdate, contract.id, acc.Id, listWrapperIdCMBA, listidAd);
			adc1.Street__c = 'Street';
			adc1.PostalCode__c = '13000';
			adc1.ADRComplement__c = 'ADR';
			adc1.Country__c = 'France';
			adc1.City__c = 'Marseille';
			adc1.Representant_BillTo__c = 'Kamel';
			adc1.attention_de__c = 'CPCUUU';

			update adc1;

			Test.stopTest();
		}


	}
}