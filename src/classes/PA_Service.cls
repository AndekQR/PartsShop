public virtual class PA_Service {
    public virtual List<String> getIds(List<SObject> objects) {
        List<String> ids = new List<String>();
        for (SObject sobj : objects) {
            ids.add(sobj.Id);
        }
        return ids;
    }
}