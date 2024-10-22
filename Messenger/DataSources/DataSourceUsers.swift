import IGListKit

class DataSourceUsers: NSObject, ListAdapterDataSource {
    
    var items = [ListDiffable]()
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is UserArray:
            return SectionControllerUsers()
        default:
            return SectionControllerLoading()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
