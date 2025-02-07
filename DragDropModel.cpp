#include "DragDropModel.h"

DragDropModel::DragDropModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int DragDropModel::rowCount(const QModelIndex &parent) const
{
    return m_items.size();
}

QVariant DragDropModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_items.size())
        return QVariant();

    const auto &item = m_items[index.row()];
    switch (role) {
    case NameRole: return item.name;
    case XRole: return item.x;
    case YRole: return item.y;
    case ColorRole: return item.color;
    default: return QVariant();
    }
}

QHash<int, QByteArray> DragDropModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[XRole] = "x";
    roles[YRole] = "y";
    roles[ColorRole] = "color";
    return roles;
}

void DragDropModel::addItem(const QString &name, qreal x, qreal y, const QString &color)
{
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append({name, x, y, color});
    endInsertRows();
}

void DragDropModel::removeItem(int index)
{
    if (index < 0 || index >= m_items.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
}
