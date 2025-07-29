public with sharing class PetVaccinationBatch implements Database.Batchable<SObject>, Database.Stateful {

    private static final Integer ALERT_DAYS = 7;

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date limitDate = Date.today().addDays(ALERT_DAYS);
        return Database.getQueryLocator([
            SELECT Id, Name, Next_Vaccination_Date__c
            FROM Pet__c
            WHERE Next_Vaccination_Date__c <= :limitDate
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Pet__c> pets) {
        // Buscar el primer administrador activo
        User adminUser = [
            SELECT Id 
            FROM User 
            WHERE Profile.Name = 'System Administrator' 
            AND IsActive = TRUE 
            LIMIT 1
        ];

        List<Task> tasksToInsert = new List<Task>();

        for (Pet__c pet : pets) {
            // Verificar si ya existe una Task abierta para este Pet
            Boolean alreadyExists = [
                SELECT COUNT() 
                FROM Task
                WHERE WhatId = :pet.Id
                AND Status != 'Completed'
                AND Subject = :('Vaccination overdue: ' + pet.Name)
            ] > 0;

            if (!alreadyExists) {
                tasksToInsert.add(new Task(
                    Subject = 'Vaccination overdue: ' + pet.Name,
                    WhatId = pet.Id,
                    OwnerId = adminUser.Id,
                    Status = 'Not Started',
                    Priority = 'High',
                    ActivityDate = Date.today()
                ));
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Vaccination reminder tasks created successfully.');
    }
}
